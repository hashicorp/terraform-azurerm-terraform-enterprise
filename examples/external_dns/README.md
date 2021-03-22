# EXAMPLE: Deploying Terraform Enterprise in Active/Active Mode with external DNS

## About This Example

This examples serves as a reference for running Terraform Enterprise in Active/Active mode with DNS managed outside of the module and/or Azure itself. [Active/Active](https://www.terraform.io/docs/enterprise/before-installing/reference-architecture/azure.html#active-active-implementation-mode) implementation mode is an extension of the Standalone implementation mode that increases the scalability and load capacity of the Terraform Enterprise platform. The same application runs on multiple Terraform Enterprise instances utilizing the same external services in a shared model.

## How To Use This Module

To run this module with an Active/Active configuration and external DNS:
* The number value supplied for `vm_node_count` must be greater than or equal to 2 and less than or equal to 5
* The boolean value for `dns_create_record` must be set to false
* The string value for `dns_external_fqdn` must be set to external fully qualified domain name

The module will provide all other resources necessary for an Active/Active configuration and will output the IP address of the load balancer or application gateway. You may use this IP address to configure an external DNS record.

Variables may be supplied for this example to deploy the root module in the active/active configuration with external DNS. The configuration below serves as an independent reference for the same.

```hcl
provider "azurerm" {
  features {}
}

module "tfe" {
  source = "git@github.com:hashicorp/espd-tfe-azure.git"

  friendly_name_prefix = "<Friendly name to use for resources>"
  tfe_license_filepath = "${path.module}/files/license.rli"

  resource_group_name = "<Existing Azure Resource Group to build TFE environment within>"

  key_vault_name   = "<Existing Azure Key Vault name>"
  certificate_name = "<Existing Azure Key Vault Certificate name>"

  vm_node_count = 2

  # External DNS information
  dns_create_record = false
  dns_external_fqdn = "<External fully qualified domain name>"
}
```

Refer to the root module's instructions for [setup instructions](../../README.md#How-to-Use-This-Module).

Refer to the AzureRM provider article on [authentication](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs) for instructions on how to authenticate with Azure.

With authentication configured, run `terraform init` and `terraform apply` to provision the example infrastructure.

## Variable Input

The required and optional variable inputs described in this document serve as a reference configuration. The root module provides many other optional variable inputs.

### Required Inputs For This Example

| Name | Description | Type | Example Value |
|------|-------------|------| ------------- |
| `friendly_name_prefix` | Name prefix used for resources | string | somename |
| `tfe_license_path` | Local path to the TFE license | string | /files/license.rli |
| `vm_node_count` | Number of virtual machines | number | 2 |
| `dns_create_record` | Determine if root module should create a DNS record or not | bool | false |
| `dns_external_fqdn` | Fully qualified domain name of external DNS record which will be used | string | tfe.example.com |

### Optional Inputs For This Example

| Name | Description | Type | Example Value |
|------|-------------|------| ------------- |
| `location` | Azure location | string | East US |
| `resource_group_name` | Existing Azure Resource Group to build TFE environment within | string | myrg |
| `key_vault_name` | Name of an existing Key Vault | string | mykv |
| `certificate_name` | Name of an existing Key Vault Ceritificate within `key_vault_name` | string | mycert |
| `tags` | Map of tags to use for resources | map(string) | {} |
