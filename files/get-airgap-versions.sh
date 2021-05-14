#!/bin/bash

# export LICENSE_ID=""
# export PASSWORD=""

[[ -z "$LICENSE_ID" ]] && echo "Please Set LICENSE_ID Environment Variable" && exit 1
[[ -z "$PASSWORD" ]] && echo "Please Set PASSWORD Environment Variable" && exit 1

b64_password=$(echo -n ${PASSWORD} | base64)

# Get all releases so we can pull the label
all_releases=$(curl -s \
-H "Authorization: Basic ${b64_password}" \
-H "Accept: application/json" \
"https://api.replicated.com/market/v1/airgap/releases?license_id=${LICENSE_ID}")
# echo $all_releases > all_releases.json

echo "Seq  Label"
echo ${all_releases} | jq -r '.releases[:10] | .[] | "\(.release_sequence)  \(.label)"'   
