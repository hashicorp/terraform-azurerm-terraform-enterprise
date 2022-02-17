# EXAMPLE: Standalone, Mounted Disk, Airgapped Installation of Terraform Enterprise

## About this example

This example for Terraform Enterprise creates a TFE
installation with the following traits.

- Standalone
- Airgapped installation
- Mounted Disk mode
- a small VM machine type (Standard_D4_v3)
- Ubuntu 20.04 as the VM image
- a publicly accessible HTTP load balancer with TLS termination

## Pre-requisites

This example assumes that the user wishes for the prerequisites to be installed, too,
by setting the boolean variable `bootstrap_airgap_installation` to `true`. When `true`,
this example assumes that the following resources exist:

- a DNS zone
- an Azure Key Vault in which the following are stored:
  - Key Vault secret which contains the Base64 encoded version of a PEM encoded public
    certificate for the Virtual Machine Scale Set
  - Key Vault secret which contains the Base64 encoded version of a PEM encoded private
    key for the Virtual Machine Scale Set.
- TFE license on a filepath accessible by tests
- The URL of an airgap package
