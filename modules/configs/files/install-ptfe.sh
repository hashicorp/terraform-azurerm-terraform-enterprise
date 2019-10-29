#!/bin/bash

set -e -u -o pipefail

### Set proxy variables, if needed.
if [ -s /etc/ptfe/proxy-url ]; then
  http_proxy=$(cat /etc/ptfe/proxy-url)
  https_proxy=$(cat /etc/ptfe/proxy-url)
  export http_proxy
  export https_proxy
  export no_proxy=10.0.0.0/8,127.0.0.1,169.254.169.254
fi

### Decide on distribution specific things
if [ -f /etc/redhat-release ]; then
  CONF=/etc/chrony.conf
  SERVICE=chronyd
  setenforce 0
  mkdir -p /lib/tc
  mount --bind /usr/lib64/tc/ /lib/tc/
  sed -i -e 's/^SELINUX=enforcing/SELINUX=permissive/' /etc/sysconfig/selinux
  sed -i -e '/rhui-REGION-rhel-server-extras/,/^$/s/enabled=0/enabled=1/g'  /etc/yum.repos.d/redhat-rhui.repo
  yum -y install docker wget jq chrony ipvsadm unzip
  # remove after testing rhui?
  # curl -sfSL -o /usr/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64
  # chmod +x /usr/bin/jq
  systemctl enable docker
  systemctl start docker
else
  apt-get update -y
  apt-get install -y jq chrony ipvsadm unzip wget
  CONF=/etc/chrony/chrony.conf
  SERVICE=chrony
fi

# From the Azure documentation on time sync
# https://docs.microsoft.com/en-us/azure/virtual-machines/linux/time-sync
echo "Enable NTP support..."
echo "refclock PHC /dev/ptp0 poll 3 dpoll -2 offset 0" > /tmp/chrony.conf
cat "${CONF}" >> /tmp/chrony.conf
cp /tmp/chrony.conf "${CONF}"
systemctl restart "${SERVICE}"

pushd /tmp
  wget -O ptfe.zip "$(cat /etc/ptfe/ptfe_url)"
  unzip ptfe.zip
  cp ptfe /usr/bin
  chmod a+x /usr/bin/ptfe
popd

role="$(cat /etc/ptfe/role)"
export role


if [ "x${role}x" == "xmainx" ]; then
  # Get the tls certs set up.
  cert_thumbprint=$(cat /etc/ptfe/cert_thumbprint)
  ln -s "/var/lib/waagent/${cert_thumbprint}.crt" /etc/ptfe/tls.crt
  ln -s "/var/lib/waagent/${cert_thumbprint}.prv" /etc/ptfe/tls.key
fi

private_ip=$(curl -H Metadata:true "http://169.254.169.254/metadata/instance/network?api-version=2017-08-01" | jq -r .interface[0].ipv4.ipAddress[0].privateIpAddress)
public_ip=$(curl -H Metadata:true "http://169.254.169.254/metadata/instance/network/?api-version=2017-08-01" | jq -r .interface[0].ipv4.ipAddress[0].publicIpAddress)

airgap_url_path="/etc/ptfe/airgap-package-url"
airgap_installer_url_path="/etc/ptfe/airgap-installer-url"
weave_cidr="/etc/ptfe/weave-cidr"
repl_cidr="/etc/ptfe/repl-cidr"





health_url="$(cat /etc/ptfe/health-url)"

ptfe_install_args=(
    -DD
    "--bootstrap-token=$(cat /etc/ptfe/bootstrap-token)" \
    "--cluster-api-endpoint=$(cat /etc/ptfe/cluster-api-endpoint)" \
    --health-url "$health_url"
    --assistant-host "$(cat /etc/ptfe/assistant-host)"
    --assistant-token "$(cat /etc/ptfe/assistant-token)"
)

role_id=0

if test -e /etc/ptfe/role-id; then
    role_id="$(cat /etc/ptfe/role-id)"
    ptfe_install_args+=(
        --role-id "$role_id"
    )
fi

if [ "x${role}x" == "xmainx" ]; then
    verb="setup"
    export verb
    # main
    ptfe_install_args+=(
        "--private-address=${private_ip}"
        "--public-address=${public_ip}"
        --cluster
        "--auth-token=@/etc/ptfe/setup-token"
    )

    if [ -s /etc/ptfe/proxy-url ]; then
        ptfe_install_args+=(
            "--additional-no-proxy=$no_proxy"
        )
    fi
    # If we are airgapping, then set the arguments needed for Replicated.
    # We also setup the replicated.conf.tmpl to include the path to the downloaded
    # airgap file.
    if test -e "$airgap_url_path"; then
        mkdir -p /var/lib/ptfe
        pushd /var/lib/ptfe
        airgap_url="$(< "$airgap_url_path")"
        echo "Downloading airgap package from $airgap_url"
        ptfe util download "$airgap_url" /var/lib/ptfe/ptfe.airgap
        popd
    fi

    if test -e "$weave_cidr"; then
      ptfe_install_args+=(
          "--ip-alloc-range=$(cat /etc/ptfe/weave-cidr)"
      )
    fi

    if test -e "$repl_cidr"; then
      ptfe_install_args+=(
          "--service-cidr=$(cat /etc/ptfe/repl-cidr)"
      )
    fi

    # ------------------------------------------------------------------------------
    # Custom CA certificate download and configuration block
    # ------------------------------------------------------------------------------
    if [[ -n $(< /etc/ptfe/custom-ca-cert-url) && \
          $(< /etc/ptfe/custom-ca-cert-url) != none ]]; then
      custom_ca_bundle_url=$(cat /etc/ptfe/custom-ca-cert-url)
      custom_ca_cert_file_name=$(echo "${custom_ca_bundle_url}" | awk -F '/' '{ print $NF }')
      ca_tmp_dir="/tmp/ptfe-customer-certs"
      replicated_conf_file="replicated-ptfe.conf"
      local_messages_file="local_messages.log"
      # Setting up a tmp directory to do this `jq` transform to leave artifacts if anything goes "boom",
      # since we're trusting user input to be both a working URL and a valid certificate.
      # These artifacts will live in /tmp/ptfe/customer-certs/{local_messages.log,wget_output.log} files.
      mkdir -p "${ca_tmp_dir}"
      pushd "${ca_tmp_dir}"
      touch ${local_messages_file}
      if wget --trust-server-names "${custom_ca_bundle_url}" >> ./wget_output.log 2>&1;
      then
        if [ -f "${ca_tmp_dir}/${custom_ca_cert_file_name}" ];
        then
          if openssl x509 -in "${custom_ca_cert_file_name}" -text -noout;
          then
            mv "${custom_ca_cert_file_name}" cust-ca-certificates.crt
            cp /etc/${replicated_conf_file} ./${replicated_conf_file}.original
            jq ". + { ca_certs: { value: \"$(cat cust-ca-certificates.crt)\" } }" -- ${replicated_conf_file}.original > ${replicated_conf_file}.updated
            if jq -e . > /dev/null 2>&1 -- ${replicated_conf_file}.updated;
            then
              cp ./${replicated_conf_file}.updated /etc/${replicated_conf_file}
            else
              echo "The updated ${replicated_conf_file} file is not valid JSON." | tee -a "${local_messages_file}"
              echo "Review ${ca_tmp_dir}/${replicated_conf_file}.original and ${ca_tmp_dir}/${replicated_conf_file}.updated." | tee -a "${local_messages_file}"
              echo "" | tee -a "${local_messages_file}"
            fi
          else
            echo "The certificate file wasn't able to validated via openssl" | tee -a "${local_messages_file}"
            echo "" | tee -a "${local_messages_file}"
          fi
        else
          echo "The filename ${custom_ca_cert_file_name} was not what ${custom_ca_bundle_url} downloaded." | tee -a "${local_messages_file}"
          echo "Inspect the ${ca_tmp_dir} directory to verify the file that was downloaded." | tee -a "${local_messages_file}"
          echo "" | tee -a "${local_messages_file}"
        fi
      else
        echo "There was an error downloading the file ${custom_ca_cert_file_name} from ${custom_ca_bundle_url}." | tee -a "${local_messages_file}"
        echo "See the ${ca_tmp_dir}/wget_output.log file." | tee -a "${local_messages_file}"
        echo "" | tee -a "${local_messages_file}"
      fi

      popd
    fi
else
    # We do this before continuing so that the airgap_installer_url can reference
    # the internal load balancer and retrieve files from the primary
    echo "Waiting for cluster to start before continuing..."
    ptfe install join --role-id "$role_id" --health-url "$health_url" --wait-for-cluster
fi

if [ "x${role}x" != "xsecondaryx" ]; then
    ptfe_install_args+=(
        --primary-pki-url "$(cat /etc/ptfe/primary-pki-url)"
    )
fi

if [ "x${role}x" == "xprimaryx" ]; then
    verb="join"
    ptfe_install_args+=(
        --as-primary
    )
    export verb
fi

if [ "x${role}x" == "xsecondaryx" ]; then
    verb="join"
    export verb
fi

if test -e "$airgap_installer_url_path"; then
    mkdir -p /var/lib/ptfe
    pushd /var/lib/ptfe
    airgap_installer_url="$(< "$airgap_installer_url_path")"
    echo "Downloading airgap installer from $airgap_installer_url"
    ptfe util download "$airgap_installer_url" /var/lib/ptfe/replicated.tar.gz
    popd

    ptfe_install_args+=(
        --airgap-installer /var/lib/ptfe/replicated.tar.gz
    )
fi

echo "Running 'ptfe install $verb"  "${ptfe_install_args[@]}" "''"
ptfe install $verb "${ptfe_install_args[@]}"
