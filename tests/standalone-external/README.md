# TEST: Standalone External Services Terraform Enterprise

## About this test

This test for Terraform Enterprise creates a TFE
installation with the following traits.

- Standalone
- Production mode
- a small VM machine type (Standard_D4_v3)
- Ubuntu 20.04 as the VM image
- a publicly accessible HTTP load balancer with TLS termination
- no proxy server
- External PostgreSQL
- External Redis
  - no Redis authentication
  - no Redis encryption in transit
- Storage account

## Pre-requisites

This test assumes the following resources exist.

- a DNS zone
- an Azure Key Vault in which the following are stored:
  - Base64 encoded TFE license (secret)
  - TFE CA certificate (certificate)
- TFE license on a filepath accessible by tests

## How this test is used

This test is leveraged by the integration tests in the [`ptfe-replicated`](https://github.com/hashicorp/ptfe-replicated/blob/master/.circleci/config.yml)
repository.
