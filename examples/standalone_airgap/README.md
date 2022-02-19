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

This example assumes that it is being run in a completely air-gapped environment and that the
user has already prepared the virtual machine (vm) image with the prerequisites for an airgapped
installation. This requires the following:

- a DNS zone
- The vm image is prepared according to the [documentation](https://www.terraform.io/enterprise/install/interactive/installer#prepare-the-instance).
- TFE license is on a filepath defined by `var.tfe_license_file_location`.
- The airgap package is on a filepath defined by `var.tfe_license_bootstrap_airgap_package_path`.
- The extracted Replicated package from 
https://s3.amazonaws.com/replicated-airgap-work/replicated.tar.gz is at
`/tmp/replicated/replicated.tar.gz`.
- Certificate and key data is present on the vm image at the following paths (when applicable):
  - `vm_certificate` value at the path defined by `var.tls_bootstrap_cert_pathname` (`0600` access permissions)
  - `vm_key` value at the path defined by `var.tls_bootstrap_key_pathname` (`0600` access permissions)
  - `ca_certificate` value at the path:
    - for Red Hat - `/usr/share/pki/ca-trust-source/anchors/tfe-ca-certificate.crt`
    - for Ubuntu - `/usr/local/share/ca-certificates/extra/tfe-ca-certificate.crt`
