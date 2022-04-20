# TEST: Standalone Mounted Disk Mode Terraform Enterprise

## About this test

This test for Terraform Enterprise creates a TFE
installation with the following traits.

- Standalone
- Mounted Disk mode
- a small VM machine type (Standard_D4_v3)
- Ubuntu 20.04 as the VM image
- a publicly accessible HTTP load balancer with TLS termination

## Pre-requisites

This test assumes the following resources exist.

- a DNS zone
- an Azure Key Vault in which the following are stored:
  - TFE CA certificate (certificate)
  - Key Vault secret which contains the Base64 encoded version of a PEM encoded public
    certificate for the Virtual Machine Scale Set
  - Key Vault secret which contains the Base64 encoded version of a PEM encoded private
    key for the Virtual Machine Scale Set.
- TFE license on a filepath accessible by tests

These are the certificate and key for the VM, not for a CA, as the application gateway requires its backend to also have a trusted TLS certificate.
## How this test is used

This test is leveraged by the integration tests in the [`ptfe-replicated`](https://github.com/hashicorp/ptfe-replicated/blob/main/.circleci/config.yml)
repository.
