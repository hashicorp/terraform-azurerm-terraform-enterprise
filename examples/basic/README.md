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

To use this example, copy the configs to their respective files in an empty directory on a computer that has API access to Azure (Local computer or server with access), fill in the local variables in a terraform.tfvars file and add any optional parameters to the module with your configurations and run terraform init, plan, and apply, once the apply has completed, wait for the application to load as the installer dashboard url will be included in the `tfe_cluster` output map.

## Example

### variables.tf

```hcl
variable "resource_group" {
  description = "Azure resource group the vnet, key vault, and dns domain exist in."
}

variable "vnet_name" {
  description = "Azure virtual network name to deploy in."
}

variable "subnet_name" {
  description = "Azure subnet within the virtual network to deploy in."
}

variable "dns_domain" {
  description = "Azure hosted DNS domain"
}

variable "key_vault_name" {
  description = "Azure hosted Key Vault resource."
}

variable "certificate_path" {
  description = "Path to a TLS wildcard certificate for the domain in PKCS12 format."
}

variable "certificate_pass" {
  description = "The Password for the PKCS12 Certificate."
}

variable "license_path" {
  description = "Path to the RLI lisence file for Terraform Enterprise."
}
```

### main.tf

```hcl
provider "azurerm" {
  version = "~>1.32.1"
}

module "tfe_cluster" {
  source  = "hashicorp/terraform-enterprise/azurerm"
  version = "0.0.4-beta"

  license_file                 = "${var.license_path}"
  resource_group_name          = "${var.resource_group}"
  virtual_network_name         = "${var.vnet_name}"
  subnet                       = "${var.subnet_name}"
  key_vault_name               = "${var.key_vault_name}"
  domain                       = "${var.dns_domain}"
  tls_pfx_certificate          = "${var.certificate_path}"
  tls_pfx_certificate_password = "${var.certificate_pass}"
}
```

### outputs.tf

```hcl
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
