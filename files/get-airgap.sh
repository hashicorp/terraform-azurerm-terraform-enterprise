#!/bin/bash

# export LICENSE_ID=""
# export PASSWORD=""

release_sequence=$1

[[ -z "$LICENSE_ID" ]] && echo "Please Set LICENSE_ID Environment Variable" && exit 1
[[ -z "$PASSWORD" ]] && echo "Please Set PASSWORD Environment Variable" && exit 1
[[ -z "$release_sequence" ]] && echo "Please Pass a release sequence number" && exit 1

b64_password=$(echo -n ${PASSWORD} | base64)

# Get all releases so we can pull the label
all_releases=$(curl -s \
-H "Authorization: Basic ${b64_password}" \
-H "Accept: application/json" \
"https://api.replicated.com/market/v1/airgap/releases?license_id=${LICENSE_ID}")
# echo $all_releases > all_releases.json

# Get the specific release airgap so we can get the generated URL
replicated_release=$(curl -s \
-H "Authorization: Basic ${b64_password}" \
-H "Accept: application/json" \
"https://api.replicated.com/market/v1/airgap/images/url?license_id=${LICENSE_ID}&sequence=${release_sequence}")
# echo $replicated_release > replicated_release.json

label=$(echo ${all_releases} | jq -r ".releases[] | select(.release_sequence == ${release_sequence}) | .label")
url=$(echo ${replicated_release} | jq -r '.url')
filename="${label}(${release_sequence}).airgap"

echo
echo "Found TFE release:"
echo "  Sequence: ${release_sequence}"
echo "  Label: ${label}"
echo
echo "Generated URL:"
echo "  URL: ${url}"
echo "  Filename: ${filename}"
echo

curl -o ${filename} ${url}