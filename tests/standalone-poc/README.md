# TEST: Standalone POC Mode Terraform Enterprise

## About this test

This test for Terraform Enterprise creates a TFE
installation with the following traits.

- Standalone
- POC / Demo-mode
- a small VM machine type (Standard_D4_v3)
- Ubuntu 20.04 as the VM image
- a publicly accessible HTTP load balancer with TLS termination

## Pre-requisites

This test assumes the following resources exist.

- a DNS zone
- an Azure Key Vault in which the following are stored:
  - Base64 encoded TFE license (secret)
  - TFE CA certificate (certificate)
- TFE license on a filepath accessible by tests

## How this test is used

This test is leveraged by the integration tests in the `ptfe-replicated` repository.
