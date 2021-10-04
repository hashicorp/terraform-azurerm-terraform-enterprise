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

echo "[$(date +"%FT%T")] Install JQ" | tee -a /var/log/ptfe.log
curl --noproxy '*' -Lo /bin/jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64
chmod +x /bin/jq

echo "[$(date +"%FT%T")] Downloading Public Certificate and Private Key" | tee -a /var/log/ptfe.log
# Obtain access token for Azure Key Vault
access_token=$(curl 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https://vault.azure.net' -H Metadata:true | jq -r .access_token)
certificate_data_b64=$(curl --noproxy '*' ${certificate_secret_id}?api-version=2016-10-01 -H "x-ms-version: 2017-11-09" -H "Authorization: Bearer $access_token" | jq -r .value)
key_data_b64=$(curl --noproxy '*' ${key_secret_id}?api-version=2016-10-01 -H "x-ms-version: 2017-11-09" -H "Authorization: Bearer $access_token" | jq -r .value)

echo "[$(date +"%FT%T")]  Deploying Public Certificate and Private Key for mitmproxy" | tee -a /var/log/ptfe.log
cat <<EOF >/etc/mitmproxy/mitmproxy-ca.pem
$(echo $certificate_data_b64 | base64 --decode)
$(echo $key_data_b64 | base64 --decode)
EOF

echo "[$(date +"%FT%T")]  Starting mitmproxy service" | tee -a /var/log/ptfe.log
systemctl daemon-reload
systemctl start mitmproxy
systemctl enable mitmproxy

duration=$SECONDS #Stop Time
echo "[$(date +"%FT%T")]  Finished mitmproxy startup script." | tee -a /var/log/ptfe.log
echo "  $(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
