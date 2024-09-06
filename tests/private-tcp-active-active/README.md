# TEST: Private TCP Active/Active Terraform Enterprise

## About this test

This test for Terraform Enterprise creates a TFE
installation with the following traits.

- Active/Active mode
- Large instance size (32 vCPUs)
- RHEL as the operating system
- SELinux enabled
- An internally exposed network
- MITM proxy
- TCP load balancer
- End to end TLS
- External PostgreSQL
- External Redis
- Redis authentication enabled
- Redis encryption in transit
- Redis encryption at rest

## Pre-requisites

This test assumes the following resources exist.

- a DNS zone
- an Azure Key Vault in which the following are stored:
  - TFE CA certificate pem (secret)
  - TFE CA certificate key (secret)
  - proxy CA certificate key (secret)
  - proxy CA certificate private key (secret)
  - proxy SSH public key (secret)
  - proxy SSH private key (secret)
  - bastion SSH public key (secret)
  - bastion SSH private key (secret)
  - base64 encoded TFE license (secret)

## How this test is used

This test is leveraged by this repository's continuous integration setup which
leverages workspaces in a Terraform Cloud workspaces as a remote backend so that
Terraform state is preserved.