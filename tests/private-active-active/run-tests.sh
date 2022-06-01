#!/bin/bash

k6_path=""
k6_tests_dir=""
bastion_key_file=""
skip_init=""
bind_to_localhost=""

Help()
{
   # Display Help
   echo "Add description of the script functions here."
   echo
   echo "Syntax: run-tests.sh [-h|k|t]"
   echo "options:"
   echo "h     Print this Help."
   echo "k     (required) The path to the k6 binary."
   echo "t     (required) The path to the tfe-load-test repository."
   echo "b     (required) The path to the bastion server ssh private key."
   echo "s     (optional) Skip the admin user initialization and tfe token retrieval (This is useful for secondary / repeated test runs)."
   echo "l     (optional) Bind the test proxy to localhost instead of the detected ip address (This is useful when testing from within a docker container)."
   echo
}

# Get the options
while getopts ":hk:t:b:sl" option; do
   case $option in
      h) # display Help
         Help
         exit;;
      k) # Enter a path to the k6 binary
         k6_path=$OPTARG;;

      t) # Enter a path to the tfe-load-test repo
         k6_tests_dir=$OPTARG;;
      b) # Enter a path to the bastion server ssh private key
         bastion_key_file=$OPTARG;;
      s) # Skip the admin user boostrapping process?
         skip_init=1;;
      l) # Bind test proxy to localhost
         bind_to_localhost=1;;   
     \?) # Invalid option
         echo "Error: Invalid option"
         exit;;
   esac
done

if [[ -z "$k6_path" ]]; then
    echo "k6 path missing. Please use the -k option."
    Help
    exit 1
fi

if [[ -z "$k6_tests_dir" ]]; then
    echo "The tfe-load-test repository path missing. Please use the -t option."
    Help
    exit 1
fi

if [[ -z "$bastion_key_file" ]]; then
    echo "The bastion key file path is missing. Please use the -b option."
    Help
    exit 1
fi

echo "
Executing tests with the following configuration:

    k6_path=$k6_path
    k6_tests_dir=$k6_tests_dir
    bastion_key_file=$bastion_key_file
    skip_init=$skip_init
    bind_to_localhost=$bind_to_localhost
"

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";

cd $SCRIPT_DIR
health_check_url=$(terraform output -no-color -raw health_check_url)
echo "health check url: $health_check_url"
bastion_fqdn=$(terraform output -no-color -raw bastion_fqdn)

# Start socks proxy
echo "bastion fqdn: $bastion_fqdn"

host_ip=""
if [[ -z "$bind_to_localhost" ]]; then
  host_ip=$(hostname -I | xargs)
else
  host_ip="localhost"
fi
echo "host interface is: $host_ip"

socks_port=8082
proxy=socks5://$host_ip:$socks_port
echo "proxy will be: $proxy"
ssh \
    -o 'BatchMode yes' \
    -o 'StrictHostKeyChecking accept-new' \
    -i $bastion_key_file \
    -f -N -p 22 -D $host_ip:$socks_port \
    -S /tmp/.private-active-active \
    bastionuser@"$bastion_fqdn"

ssh_pid=$(pgrep -f 'ssh.*-f')
trap "{ kill $ssh_pid ; }" EXIT

if [[ -z "$skip_init" ]]; then
    # Execute Tests
    echo "Curling \`health_check_url\` for a return status of 200..."
    while ! curl -sfS --max-time 5 --proxy $proxy $health_check_url; \
    do sleep 5; done
    echo " : TFE is healthy and listening."

    tfe_url=$(terraform output -no-color -raw tfe_url)
    echo "tfe url: $tfe_url"
    iact_url=$(terraform output -no-color -raw iact_url)
    echo "iact url: $iact_url"
    echo "Fetching iact token.."
    iact_token=$(curl --fail --proxy $proxy "$iact_url")

    echo "iact token: $iact_token"
    admin_url=$(terraform output -no-color -raw initial_admin_user_url)
    TFE_USERNAME="test$(date +%s)"
    TFE_PASSWORD=$(openssl rand -base64 32)
    echo "{\"username\": \"$TFE_USERNAME\", \"email\": \"$TFE_USERNAME@example.com\", \"password\": \"$TFE_PASSWORD\"}" \
        > ./payload.json
    response=$( \
                curl \
                --fail \
                --retry 5 \
                --header 'Content-Type: application/json' \
                --data @./payload.json \
                --proxy $proxy \
                "$admin_url"?token="$iact_token")
    tfe_token=$(echo "$response" | jq --raw-output '.token')
    rm -f payload.json
    echo "tfe_token: $tfe_token"

    echo "export K6_PATHNAME=$k6_path
    export TFE_URL=$tfe_url
    export TFE_API_TOKEN=$tfe_token
    export TFE_EMAIL=$TFE_USERNAME@example.com
    export http_proxy=$proxy
    export https_proxy=$proxy" > .env.sh

    echo "Sleeping for 3 minutes to ensure that both instances are ready."
    sleep 180
fi

source .env.sh
cd $k6_tests_dir
make smoke-test
