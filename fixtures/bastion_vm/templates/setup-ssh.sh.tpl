i=0
%{ for config in ssh_config ~}
  ((i=i+1))
  echo "${config}" > ~/.ssh/ssh_config_$i
%{ endfor ~}

echo "${private_key_data}" | base64 -d > ${private_key_path}
chmod 400 ${private_key_path}