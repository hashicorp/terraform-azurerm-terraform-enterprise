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

echo "[$(date +"%FT%T")]  Deploying certificates for mitmproxy" | tee -a /var/log/ptfe.log
cat <<EOF >/etc/mitmproxy/mitmproxy-ca.pem
${ca_certificate}
${ca_private_key}
EOF

echo "[$(date +"%FT%T")]  Starting mitmproxy service" | tee -a /var/log/ptfe.log
systemctl daemon-reload
systemctl start mitmproxy
systemctl enable mitmproxy

duration=$SECONDS #Stop Time
echo "[$(date +"%FT%T")]  Finished mitmproxy startup script." | tee -a /var/log/ptfe.log
echo "  $(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
