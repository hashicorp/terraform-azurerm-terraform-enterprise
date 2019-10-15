# Terraform Enterprise with Clustering - Basic example

This is a basic example of how to set up the configurations to use this module. Please see the [inputs page](https://registry.terraform.io/modules/terraform-enterprise/azurerm/0.0.4-beta?tab=inputs) for more details on usage.

## Prerequisites

* A computer with:
  * API access to Azure Cloud.
  * The ability to perform terraform runs.
* The pre-existing Azure resources as listed in the next section.

### Pre-Existing Resources

The following resources are assumed to already exist within your Azure subscription.

* Resource Group
* Virtual Network
* Subnet with attached Network Security Group
* Azure Hosted DNS Domain within the Resource Group
* Key Vault within the Resource Group

In addition, a PKCS12 wildcard certificate for the dns domain specified above is required.

## Usage

There are two easy ways to use this example.

1. In an empty directory
    1. Copy the configs detailed below to respectively named files.
    1. Either through environment variables, or with a terraform.tfvars file, fill in the variable parameters.
    1. Add any additional, or optional parameters to the module configuration in the main.tf file as needed.
    1. Perform the `terraform init`, `terraform plan`, and `terraform apply`
        1. Once the apply has completed, wait for the application to load, the installer dashboard url will be included in the `tfe_cluster` output map.
1. After cloning the source repository for this module
    1. Either through environment variables, or with a terraform.tfvars file, fill in the variable parameters.
    1. Add any additional, or optional parameters to the module configuration in the main.tf file as needed.
    1. Perform the `terraform init`, `terraform plan`, and `terraform apply`
        1. Once the apply has completed, wait for the application to load, the installer dashboard url will be included in the `tfe_cluster` output map.

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
    application_health_check     = "${module.tfe_cluster.application_health_check}"
    install_id                   = "${module.tfe_cluster.install_id}"
    installer_dashboard_endpoint = "${module.tfe_cluster.installer_dashboard_endpoint}"
    installer_dashboard_password = "${module.tfe_cluster.installer_dashboard_password}"
    primary_public_ip            = "${module.tfe_cluster.primary_public_ip}"
    ssh_config_file              = "${module.tfe_cluster.ssh_config_file}"
    ssh_private_key              = "${module.tfe_cluster.ssh_private_key}"
  }
}
```
