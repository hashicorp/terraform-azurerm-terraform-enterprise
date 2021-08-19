# TEST: Public Active/Active Terraform Enterprise

## About this test

This test for Terraform Enterprise creates a TFE
installation with the following traits.

- Active/Active mode
- a small VM machine type (Standard_D4_v3)
- Ubuntu 20.04 as the VM image
- a publicly accessible HTTP load balancer with TLS termination
- no proxy server
- no Redis authentication
- no Redis encryption in transit

## Pre-requisites

This test assumes the following resources exist.

- a DNS zone
- an Azure Key Vault in which the following are stored:
  - Base64 encoded TFE license (secret)
  - TFE CA certificate (certificate)

## How this test is used

This test is leveraged by this repository's continuous integration setup which
leverages workspaces in a Terraform Cloud workspaces as a remote backend so that
Terraform state is preserved.
