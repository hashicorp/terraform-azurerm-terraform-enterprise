#!/bin/bash

version=$1

[[ -z "$version" ]] && echo "Please Pass a version (example 2.42.5)" && exit 1

url="https://s3.amazonaws.com/replicated-airgap-work/stable/replicated-${version}%2B${version}%2B${version}.tar.gz"
filename="replicated-${version}.tar.gz"

echo
echo "Replicated:"
echo "  Version: ${version}"
echo "  URL: ${url}"
echo "  Filename: ${filename}"
echo

curl -Lo ${filename} ${url}
