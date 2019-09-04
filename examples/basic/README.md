# Terraform Enterprise: High Availability - Basic example

This is a basic example of how to set up the configurations to use this module. Please see the [inputs page](https://registry.terraform.io/modules/terraform-enterprise/azurerm/0.0.2-beta?tab=inputs) for more details on usage.

## Resources

This example assumes you have an existing

* Resource Group
* Virtual Network
* Subnet with attached Network Security Group
* Azure Hosted Domain within the Resource Group
  * PKCS12 Certificate for the domain
* Azure Key Vault within the Resource Group

## Usage

To use this example, copy the configs to a `main.tf` file in an empty directory on a computer that has API access to Azure (Local computer or server with access), fill in the local variables as well as the `existing-` prefixed parameters and any optional parameters to the module with your configurations and run terraform init, plan, and apply, once the apply has completed, wait for the application to load as the installer dashboard url will be included in the `tfe_cluster` output map.

## Example

```hcl
locals {
  license_file = "/path/to/licence/file.rli"
  cert_file    = "/path/to/domain/certificate.pfx"
  domain       = "dns.domain.example.com"
}

variable "cert_pw" {
  type        = "string"
  description = "The Password for the PFX Certificate."
}

provider "azurerm" {
  version = "~>1.32.1"
}

module "tfe_cluster" {
  source  = "hashicorp/tfe-ha/azure"
  version = "0.0.2-beta"

  license_file                 = "${local.license_file}"
  resource_group_name          = "existing-rg-name"
  virtual_network_name         = "existing-vnet-name"
  subnet                       = "existing-subnet-within-vnet-name"
  key_vault_name               = "existing-key-vault-in-rg-name"
  domain                       = "${local.domain}"
  tls_pfx_certificate          = "${local.cert_file}"
  tls_pfx_certificate_password = "${var.cert_pw}"
}

output "tfe_cluster" {
  value = {
    application_endpoint         = "${module.tfe_cluster.application_endpoint}"
    application_health_check     = "${module.tfe_cluster.health_check_endpoint}"
    install_id                   = "${module.tfe_cluster.install_id}"
    installer_dashboard_endpoint = "${module.tfe_cluster.console_endpoint}"
    installer_dashboard_password = "${module.tfe_cluster.admin_console_password}"
    primary_public_ip            = "${module.tfe_cluster.primary_public_ip}"
    ssh_config_file              = "${module.tfe_cluster.ssh_config_file}"
    ssh_private_key              = "${module.tfe_cluster.ssh_private_key}"
  }
}
```
