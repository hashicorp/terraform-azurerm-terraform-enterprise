#!/usr/bin/env bash
set -euo pipefail

i=0
%{ for config in ssh_config ~}
  ((i=i+1))
  echo "${config}" > ${ssh_config_path}$i
%{ endfor ~}

echo "${private_key_data}" | base64 -d > ${private_key_path}
chmod 400 ${private_key_path}