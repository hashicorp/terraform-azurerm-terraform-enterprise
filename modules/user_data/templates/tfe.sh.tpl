#!/usr/bin/env bash

set -e -u -o pipefail

install_jq() {
	echo "[$(date +"%FT%T")] [Terraform Enterprise] Install JQ" | tee -a /var/log/ptfe.log

	sudo curl --noproxy '*' -Lo /bin/jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64
	sudo chmod +x /bin/jq
}

create_tfe_config() {
	echo "[$(date +"%FT%T")] [Terraform Enterprise] Create configuration files" | tee -a /var/log/ptfe.log

	sudo echo "${settings}" | sudo base64 -d > /etc/ptfe-settings.json
	echo "${replicated}" | base64 -d > /etc/replicated.conf

	# if [[ $use_tls_kv_secrets == "1" ]]
	# then
		echo "[$(date +"%FT%T")] [Terraform Enterprise] Retrieve TLS Certs" | tee -a /var/log/ptfe.log

		# Obtain access token for Azure Key Vault to obtain base64 encoded TLS cert and key secrets
		access_token=$(curl 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https://vault.azure.net' -H Metadata:true | jq -r .access_token)
		tlscert=$(curl --noproxy '*' https://${key_vault_name}.vault.azure.net/secrets/${tls_bootstrap_cert_name}?api-version=2016-10-01 -H "x-ms-version: 2017-11-09" -H "Authorization: Bearer $access_token" | jq -r .value)
		tlskey=$(curl --noproxy '*' https://${key_vault_name}.vault.azure.net/secrets/${tls_bootstrap_key_name}?api-version=2016-10-01 -H "x-ms-version: 2017-11-09" -H "Authorization: Bearer $access_token" | jq -r .value)
		echo $tlscert | base64 -d > /var/lib/waagent/${tls_bootstrap_cert_name}.crt
		echo $tlskey | base64 -d > /var/lib/waagent/${tls_bootstrap_key_name}.prv
	# fi
}

proxy_config() {
	echo "[$(date +"%FT%T")] [Terraform Enterprise] Configure proxy" | tee -a /var/log/ptfe.log

	proxy_ip="${proxy_ip}"
	proxy_port="${proxy_port}"
	proxy_cert="${proxy_cert}"
	if [[ $proxy_ip != "" ]]
	then
		/bin/cat <<EOF >>/etc/environment
http_proxy="${proxy_ip}:${proxy_port}"
https_proxy="${proxy_ip}:${proxy_port}"
no_proxy="${no_proxy}"
EOF

		/bin/cat <<EOF >/etc/profile.d/proxy.sh
http_proxy="${proxy_ip}:${proxy_port}"
https_proxy="${proxy_ip}:${proxy_port}"
no_proxy="${no_proxy}"
EOF

		export http_proxy="${proxy_ip}:${proxy_port}"
		export https_proxy="${proxy_ip}:${proxy_port}"
		export no_proxy="${no_proxy}"
	
		if [[ $proxy_cert != "" ]]
		then
			# Obtain access token for Azure Key Vault to obtain cert secret
			access_token=$(curl 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https://vault.azure.net' -H Metadata:true | jq -r .access_token)
			certificate=$(curl --noproxy '*' https://${key_vault_name}.vault.azure.net/secrets/${proxy_cert_secret_name}?api-version=2016-10-01 -H "x-ms-version: 2017-11-09" -H "Authorization: Bearer $access_token" | jq -r .value)

			if [[ $DISTRO_NAME == *"Red Hat"* ]]
				then
					rhel_cert_dir=/usr/share/pki/ca-trust-source/anchors
					sudo mkdir -p $rhel_cert_dir
					echo $certificate > $rhel_cert_dir/${proxy_cert}.crt
					sudo update-ca-trust
				else
					ubuntu_cert_dir=/usr/local/share/ca-certificates/extra
					sudo mkdir -p $ubuntu_cert_dir
					echo $certificate > $ubuntu_cert_dir/${proxy_cert}.crt
					sudo update-ca-certificates
				fi
			fi

		fi
}

proxy_cert() {
	echo "[$(date +"%FT%T")] [Terraform Enterprise] Configure proxy cert" | tee -a /var/log/ptfe.log

	proxy_cert="${proxy_cert}"

	if [[ $proxy_cert != "" ]]
	then
		if [[ $DISTRO_NAME == *"Red Hat"* ]]
		then
			jq ". + { ca_certs: { value: \"$(cat /usr/share/pki/ca-trust-source/anchors/${proxy_cert}.crt)\" } }" -- /etc/ptfe-settings.json > ptfe-settings.json.updated
		else
			jq ". + { ca_certs: { value: \"$(cat /usr/local/share/ca-certificates/extra/${proxy_cert}.crt)\" } }" -- /etc/ptfe-settings.json > ptfe-settings.json.updated
		fi

		cp ./ptfe-settings.json.updated /etc/ptfe-settings.json
	fi
}

resize_lv() {
	echo "[$(date +"%FT%T")] [Terraform Enterprise] Resize RHEL logical volume" | tee -a /var/log/ptfe.log

	lvresize -r -L +20G /dev/mapper/rootvg-varlv
}

retrieve_tfe_license() {
	echo "[$(date +"%FT%T")] [Terraform Enterprise] Retrieve TFE license" | tee -a /var/log/ptfe.log

	# Obtain access token for Azure Key Vault to obtain base64 encoded TFE license secret
	access_token=$(curl 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https://vault.azure.net' -H Metadata:true | jq -r .access_token)
	license=$(curl --noproxy '*' https://${key_vault_name}.vault.azure.net/secrets/${tfe_license_secret_name}?api-version=2016-10-01 -H "x-ms-version: 2017-11-09" -H "Authorization: Bearer $access_token" | jq -r .value)
    echo $license | base64 -d > /etc/${tfe_license_name}
}

install_tfe() {
	echo "[$(date +"%FT%T")] [Terraform Enterprise] Install TFE" | tee -a /var/log/ptfe.log

	instance_ip=$(sudo curl --noproxy '*' -H Metadata:true "http://169.254.169.254/metadata/instance?api-version=2020-09-01" | jq -r .network.interface[0].ipv4.ipAddress[0].privateIpAddress)
	curl -o /tmp/install.sh https://get.replicated.com/docker/terraformenterprise/active-active
	chmod +x /tmp/install.sh

	sudo /tmp/install.sh \
		bypass-firewalld-warning \
		ignore-preflights \
		%{ if proxy_ip != "" ~}
		http-proxy="${proxy_ip}:${proxy_port}" \
		additional-no-proxy="${no_proxy}" \
		%{ else ~}
		no-proxy \
		%{ endif ~}
		%{if active_active ~}
		disable-replicated-ui \
		%{ endif ~}
		private-address=$instance_ip \
		public-address=$instance_ip \
		| tee -a /var/log/ptfe.log
	
	if [[ $DISTRO_NAME == *"Red Hat"* ]]
	then
		echo "[$(date +"%FT%T")] [Terraform Enterprise] Disable SELinux (temporary)" | tee -a /var/log/ptfe.log
		setenforce 0
		echo "[$(date +"%FT%T")] [Terraform Enterprise] Add docker0 to firewalld" | tee -a /var/log/ptfe.log
		firewall-cmd --permanent --zone=trusted --change-interface=docker0
		firewall-cmd --reload
		echo "[$(date +"%FT%T")] [Terraform Enterprise] Enable SELinux" | tee -a /var/log/ptfe.log
		setenforce 1
	fi
}

echo "[$(date +"%FT%T")] [Terraform Enterprise] Determine distribution" | tee -a /var/log/ptfe.log
DISTRO_NAME=$(grep "^NAME=" /etc/os-release | cut -d"\"" -f2)

install_jq
create_tfe_config
proxy_config
proxy_cert
retrieve_tfe_license

if [[ $DISTRO_NAME == *"Red Hat"* ]]
then
	resize_lv
fi

install_tfe
