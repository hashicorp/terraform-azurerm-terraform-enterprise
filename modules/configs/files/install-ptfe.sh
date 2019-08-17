#!/bin/bash

set -e -u -o pipefail


### Set proxy variables, if needed.
if [ -s /etc/ptfe/proxy-url ]; then
  http_proxy=$(cat /etc/ptfe/proxy-url)
  https_proxy=$(cat /etc/ptfe/proxy-url)
  export http_proxy
  export https_proxy
  export no_proxy=10.0.0.0/8,127.0.0.1,169.254.169.254
else
  no_proxy=""
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
  systemctl enable docker
  systemctl start docker
else
  CONF=/etc/chrony/chrony.conf
  SERVICE=chrony
fi

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
public_ip=$(curl -H Metadata:true "http://169.254.169.254/metadata/instance/network/?api-version=2017-08-01" | jq -r .interface[0].ipv4.ipAddress[0].publicIpAddress)}

airgap_url_path="/etc/ptfe/airgap-package-url"
airgap_installer_url_path="/etc/ptfe/airgap-installer-url"

ptfe_install_args=(
    -DD
    "--bootstrap-token=$(cat /etc/ptfe/bootstrap-token)" \
    "--cluster-api-endpoint=$(cat /etc/ptfe/cluster-api-endpoint)" \
    --health-url "$(cat /etc/ptfe/health-url)"
)

if [ "x${role}x" == "xmainx" ]; then
    verb="setup"
    export verb
    # main
    ptfe_install_args+=(
        "--private-address=${private_ip}"
        "--public-address=${public_ip}"
        --cluster
        "--auth-token=@/etc/ptfe/setup-token"
        "--additional-no-proxy=$no_proxy"
    )

    # 
    # If we are airgapping, then set the arguments needed for Replicated.
    # We also setup the replicated.conf.tmpl to include the path to the downloaded
    # airgap file.
    if test -e "$airgap_url_path"; then
        mkdir -p /var/lib/ptfe
        pushd /var/lib/ptfe
        curl -sfSL -o /var/lib/ptfe/ptfe.airgap "$(< "$airgap_url_path")"
        curl -sfSL -o /var/lib/ptfe/replicated.tar.gz "$(< "$airgap_installer_url_path")"
        popd

        ptfe_install_args+=(
            --airgap-installer /var/lib/ptfe/replicated.tar.gz
        )
    fi
fi

if [ "x${role}x" != "xsecondaryx" ]; then
    ptfe_install_args+=(
        --primary-pki-url "$(cat /etc/ptfe/primary-pki-url)"
        --role-id "$(cat /etc/ptfe/role-id)"
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



ptfe install $verb "${ptfe_install_args[@]}"
