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
}

proxy_config() {
	%{ if proxy_ip != null ~}
	echo "[$(date +"%FT%T")] [Terraform Enterprise] Configure proxy" | tee -a /var/log/ptfe.log

	proxy_ip="${proxy_ip}"
	proxy_port="${proxy_port}"
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
	%{ else ~}
	echo "[$(date +"%FT%T")] [Terraform Enterprise] Skipping proxy configuration" | tee -a /var/log/ptfe.log
	%{ endif ~}
}

certificate_config() {
	%{ if certificate_secret != null ~}
	echo "[$(date +"%FT%T")] [Terraform Enterprise] Configure TlsBootstrapCert" | tee -a /var/log/ptfe.log
	# Obtain access token for Azure Key Vault
	access_token=$(curl 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https://vault.azure.net' -H Metadata:true | jq -r .access_token)
	certificate_data_b64=$(curl --noproxy '*' ${certificate_secret.id}?api-version=2016-10-01 -H "x-ms-version: 2017-11-09" -H "Authorization: Bearer $access_token" | jq -r .value)

	mkdir -p $(dirname ${tls_bootstrap_cert_pathname})
	echo $certificate_data_b64 | base64 --decode > ${tls_bootstrap_cert_pathname}

	%{ else ~}
	echo "[$(date +"%FT%T")] [Terraform Enterprise] Skipping TlsBootstrapCert configuration" | tee -a /var/log/ptfe.log

	%{ endif ~}
	%{ if key_secret != null ~}
	echo "[$(date +"%FT%T")] [Terraform Enterprise] Configure TlsBootstrapKey" | tee -a /var/log/ptfe.log
	# Obtain access token for Azure Key Vault
	access_token=$(curl 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https://vault.azure.net' -H Metadata:true | jq -r .access_token)
	key_data_b64=$(curl --noproxy '*' ${key_secret.id}?api-version=2016-10-01 -H "x-ms-version: 2017-11-09" -H "Authorization: Bearer $access_token" | jq -r .value)

	mkdir -p $(dirname ${tls_bootstrap_key_pathname})
	echo $key_data_b64 | base64 --decode > ${tls_bootstrap_key_pathname}
	chmod 0600 ${tls_bootstrap_key_pathname}
	%{ else ~}
	echo "[$(date +"%FT%T")] [Terraform Enterprise] Skipping TlsBootstrapKey configuration" | tee -a /var/log/ptfe.log
	%{ endif ~}
}

ca_config() {
	%{ if ca_certificate_secret != null ~}
	echo "[$(date +"%FT%T")] [Terraform Enterprise] Configure CA cert" | tee -a /var/log/ptfe.log
	# Obtain access token for Azure Key Vault
	access_token=$(curl 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https://vault.azure.net' -H Metadata:true | jq -r .access_token)
	ca_certificate_data_b64=$(curl --noproxy '*' ${ca_certificate_secret.id}?api-version=2016-10-01 -H "x-ms-version: 2017-11-09" -H "Authorization: Bearer $access_token" | jq -r .value)

	ca_certificate_directory="/dev/null"
	if [[ $DISTRO_NAME == *"Red Hat"* ]]
	then
		ca_certificate_directory=/usr/share/pki/ca-trust-source/anchors
	else
		ca_certificate_directory=/usr/local/share/ca-certificates/extra
	fi

	mkdir -p $ca_certificate_directory
	echo $ca_certificate_data_b64 | base64 --decode > $ca_certificate_directory/tfe-ca-certificate.crt

	if [[ $DISTRO_NAME == *"Red Hat"* ]]
	then
		update-ca-trust
	else
		update-ca-certificates
	fi

	jq ". + { ca_certs: { value: \"$(echo $certificate_data_b64 | base64 --decode)\" } }" -- /etc/ptfe-settings.json > ptfe-settings.json.updated
	cp ./ptfe-settings.json.updated /etc/ptfe-settings.json
	%{ else ~}
	echo "[$(date +"%FT%T")] [Terraform Enterprise] Skipping CA certificate configuration" | tee -a /var/log/ptfe.log
	%{ endif ~}
}

resize_lv() {
	echo "[$(date +"%FT%T")] [Terraform Enterprise] Resize RHEL logical volume" | tee -a /var/log/ptfe.log

	lvresize -r -L +20G /dev/mapper/rootvg-varlv
}

retrieve_tfe_license() {
	echo "[$(date +"%FT%T")] [Terraform Enterprise] Retrieve TFE license" | tee -a /var/log/ptfe.log

	# Obtain access token for Azure Key Vault
	access_token=$(curl 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https://vault.azure.net' -H Metadata:true | jq -r .access_token)
	license=$(curl --noproxy '*' ${tfe_license_secret.id}?api-version=2016-10-01 -H "x-ms-version: 2017-11-09" -H "Authorization: Bearer $access_token" | jq -r .value)
    echo $license | base64 -d > ${tfe_license_pathname}
}

install_tfe() {
	echo "[$(date +"%FT%T")] [Terraform Enterprise] Install TFE" | tee -a /var/log/ptfe.log

	instance_ip=$(sudo curl --noproxy '*' -H Metadata:true "http://169.254.169.254/metadata/instance?api-version=2020-09-01" | jq -r .network.interface[0].ipv4.ipAddress[0].privateIpAddress)
	curl -o /tmp/install.sh https://get.replicated.com/docker/terraformenterprise/active-active
	chmod +x /tmp/install.sh

	sudo /tmp/install.sh \
		bypass-firewalld-warning \
		ignore-preflights \
		%{ if proxy_ip != null ~}
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
certificate_config
ca_config
retrieve_tfe_license

if [[ $DISTRO_NAME == *"Red Hat"* ]]
then
	resize_lv
fi

install_tfe
