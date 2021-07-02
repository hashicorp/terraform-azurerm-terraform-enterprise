#!/bin/bash

set -e -u -o pipefail

# Set intial start time - used to calculate total time
SECONDS=0 #Start Time

mkdir -p /etc/mitmproxy

touch /etc/systemd/system/mitmproxy.service
chown root:root /etc/systemd/system/mitmproxy.service
chmod 0644 /etc/systemd/system/mitmproxy.service

cat <<EOF >/etc/systemd/system/mitmproxy.service
[Unit]
Description=mitmproxy
ConditionPathExists=/etc/mitmproxy
[Service]
ExecStart=/usr/local/bin/mitmdump -p ${http_proxy_port} --set confdir=/etc/mitmproxy --ssl-insecure
Restart=always
[Install]
WantedBy=multi-user.target
EOF

echo "[$(date +"%FT%T")]  Downloading mitmproxy tar from the web" | tee -a /var/log/ptfe.log
curl -Lo /tmp/mitmproxy.tar.gz https://snapshots.mitmproxy.org/6.0.2/mitmproxy-6.0.2-linux.tar.gz
tar xvf /tmp/mitmproxy.tar.gz -C /usr/local/bin/

echo "[$(date +"%FT%T")] [Terraform Enterprise] Install JQ" | tee -a /var/log/ptfe.log
curl --noproxy '*' -Lo /bin/jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64
chmod +x /bin/jq

echo "[$(date +"%FT%T")]  Downloading certificates for the mitm proxy from Azure blob" | tee -a /var/log/ptfe.log
access_token=$(curl 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fstorage.azure.com%2F' -H Metadata:true | jq -r .access_token)
curl -Lo /tmp/mitm.tgz https://${bootstrap_storage_account_name}.blob.core.windows.net/${bootstrap_storage_account_container_name}/${proxy_cert_bundle_blob} -H "x-ms-version: 2017-11-09" -H "Authorization: Bearer $access_token"
tar -xvf /tmp/mitm.tgz -C /tmp
mv /tmp/.mitmproxy/* /etc/mitmproxy/

echo "[$(date +"%FT%T")]  Starting mitmproxy service" | tee -a /var/log/ptfe.log
systemctl daemon-reload
systemctl start mitmproxy
systemctl enable mitmproxy

duration=$SECONDS #Stop Time
echo "[$(date +"%FT%T")]  Finished mitmproxy startup script." | tee -a /var/log/ptfe.log
echo "  $(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."