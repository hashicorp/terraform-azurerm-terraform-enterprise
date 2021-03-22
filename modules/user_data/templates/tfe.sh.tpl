#!/usr/bin/env bash

set -e -u -o pipefail

create_tfe_config() {
	echo "[$(date +"%FT%T")] [Terraform Enterprise] Create configuration files" | tee -a /var/log/ptfe.log

	sudo echo "${settings}" | sudo base64 -d > /etc/ptfe-settings.json
	echo "${replicated}" | base64 -d > /etc/replicated.conf

	mkdir -p /etc/tfe/	
	echo ${user_data_cert} | base64 -d > /etc/tfe/tls.pem
	echo ${user_data_key} | base64 -d > /etc/tfe/tls.key
}

install_jq() {
	echo "[$(date +"%FT%T")] [Terraform Enterprise] Install JQ" | tee -a /var/log/ptfe.log

	sudo curl --noproxy '*' -Lo /bin/jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64
	sudo chmod +x /bin/jq
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

			if [[ $DISTRO_NAME == *"Red Hat"* ]]
				then
					sudo mkdir -p /usr/share/pki/ca-trust-source/anchors
					# Obtain access token for Azure Storage
					access_token=$(curl 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fstorage.azure.com%2F' -H Metadata:true | jq -r .access_token)
					# Use access token to obtain cert file
					sudo curl https://${bootstrap_storage_account_name}.blob.core.windows.net/${bootstrap_storage_account_container_name}/${proxy_cert} -H "x-ms-version: 2017-11-09" -H "Authorization: Bearer $access_token" --output /usr/share/pki/ca-trust-source/anchors/${proxy_cert}.crt
					sudo update-ca-trust
				else
					sudo mkdir -p /usr/local/share/ca-certificates/extra
					# Obtain access token for Azure Storage
					access_token=$(curl 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fstorage.azure.com%2F' -H Metadata:true | jq -r .access_token)
					# Use access token to obtain cert file
					sudo curl https://${bootstrap_storage_account_name}.blob.core.windows.net/${bootstrap_storage_account_container_name}/${proxy_cert} -H "x-ms-version: 2017-11-09" -H "Authorization: Bearer $access_token" --output /usr/local/share/ca-certificates/extra/${proxy_cert}.crt
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

apt_packages() {
	echo "[$(date +"%FT%T")] [Terraform Enterprise] Install Ubuntu packages" | tee -a /var/log/ptfe.log

	sudo apt-get update -y
	sudo apt-get install unzip -y
}

yum_packages() {
	echo "[$(date +"%FT%T")] [Terraform Enterprise] Install RHEL packages" | tee -a /var/log/ptfe.log

	sudo yum update -y
	sudo yum install unzip -y
	sudo lvresize -r -L +20G /dev/mapper/rootvg-varlv
}

retrieve_tfe_license() {
	echo "[$(date +"%FT%T")] [Terraform Enterprise] Retrieve TFE license" | tee -a /var/log/ptfe.log

	# Obtain access token for Azure Storage
	access_token=$(sudo curl --noproxy '*' 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fstorage.azure.com%2F' -H Metadata:true | jq -r .access_token)

	# Use access token to obtain license file
	sudo curl https://${bootstrap_storage_account_name}.blob.core.windows.net/${bootstrap_storage_account_container_name}/${tfe_license_name} -H "x-ms-version: 2017-11-09" -H "Authorization: Bearer $access_token" --output /etc/${tfe_license_name}
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

wait_tfe_ready() {
	echo "[$(date +"%FT%T")] [Terraform Enterprise] Wait for application" | tee -a /var/log/ptfe.log

	while ! curl -ksfS --connect-timeout 5 https://${fqdn}/_health_check; do
    	sleep 5
	done
}

echo "[$(date +"%FT%T")] [Terraform Enterprise] Determine distribution" | tee -a /var/log/ptfe.log
DISTRO_NAME=$(grep "^NAME=" /etc/os-release | cut -d"\"" -f2)

create_tfe_config
install_jq
proxy_config
proxy_cert
retrieve_tfe_license

if [[ $DISTRO_NAME == *"Red Hat"* ]]
then
	yum_packages
else
	apt_packages
fi

install_tfe
wait_tfe_ready
