#!/bin/bash

k6_path=""
k6_tests_dir=""
skip_init=""

Help()
{
   # Display Help
   echo "This script bootstraps the k6 / tfe-load-test environment and executes a smoke-test against an active TFE instance deployed with the terraform-azure-terraform-enterprise module."
   echo
   echo "Syntax: run-tests.sh [-h|k|t|s]"
   echo "options:"
   echo "h     Print this Help."
   echo "k     (required) The path to the k6 binary."
   echo "t     (required) The path to the tfe-load-test repository."
   echo "s     (optional) Skip the admin user initialization and tfe token retrieval (This is useful for secondary / repeated test runs)."
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
      s) # Skip the admin user boostrapping process?
         skip_init=1;;
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


echo "
Executing tests with the following configuration:

    k6_path=$k6_path
    k6_tests_dir=$k6_tests_dir
    skip_init=$skip_init
"

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
if [[ -z "$skip_init" ]]; then
    cd $SCRIPT_DIR
    health_check_url=$(terraform output -no-color -raw ptfe_health_check)
    echo "health check url: $health_check_url"

    # Execute Tests
    echo "Curling \`health_check_url\` for a return status of 200..."
    while ! curl -sfS --max-time 5 $health_check_url; \
    do sleep 5; done
    echo " : TFE is healthy and listening."

    tfe_url=$(terraform output -no-color -raw ptfe_endpoint)
    echo "tfe url: $tfe_url"
    iact_url=$tfe_url/admin/retrieve-iact
    echo "iact url: $iact_url"
    echo "Fetching iact token.."
    iact_token=$(curl --fail "$iact_url")
    echo "iact token: $iact_token"
    admin_url=$tfe_url/admin/initial-admin-user
    TFE_USERNAME="test$(date +%s)"
    TFE_PASSWORD=$(openssl rand -base64 32)
    echo "{\"username\": \"$TFE_USERNAME\", \"email\": \"$TFE_USERNAME@example.com\", \"password\": \"$TFE_PASSWORD\"}" > ./payload.json
    response=$( \
                curl \
                --fail \
                --retry 5 \
                --header 'Content-Type: application/json' \
                --data @./payload.json \
                "$admin_url"?token="$iact_token")
    tfe_token=$(echo "$response" | jq --raw-output '.token')
    rm -f ./payload.json
    echo "tfe_token: $tfe_token"

    echo "export K6_PATHNAME=$k6_path
    export TFE_URL=$tfe_url
    export TFE_API_TOKEN=$tfe_token
    export TFE_EMAIL=$TFE_USERNAME@example.com" > .env.sh
fi

source .env.sh
cd $k6_tests_dir
make smoke-test
