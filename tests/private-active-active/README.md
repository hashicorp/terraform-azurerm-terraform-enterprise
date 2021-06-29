# TEST: Private Active/Active Terraform Enterprise

## About this test

This test for Terraform Enterprise creates a TFE
installation with the following traits.

- Active/Active mode
- Large instance size (16 vCPUs)
- RHEL as the operating system
- An internally exposed network
- A proxy without TLS termination
- An Application Gateway
- End to end TLS
- External PostgreSQL
- External Redis
- Redis authentication enabled
- No Redis encryption in transit
- No Redis encryption at rest

## Pre-requisites

This test assumes the following resources exist.

- a Storage Account for boostrap assets
- a Blob Container inside the Storage Account for the Terraform Enterprise license
- a CA certificate
- an Azure Key Vault in which the CA certificate is stored


## How this test is used

This test is leveraged by this repository's continuous integration setup which
leverages workspaces in a Terraform Cloud workspaces as a remote backend so that
Terraform state is preserved.