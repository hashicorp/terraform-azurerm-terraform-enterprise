# EXAMPLE: Deploying Terraform Enterprise in Active/Active Mode

## About This Example

[Active/Active](https://www.terraform.io/docs/enterprise/before-installing/reference-architecture/azure.html#active-active-implementation-mode) implementation mode is an extension of the Standalone implementation mode that increases the scalability and load capacity of the Terraform Enterprise platform. The same application runs on multiple Terraform Enterprise instances utilizing the same external services in a shared model.

## How To Use This Module

To run this module with an Active/Active configuration:
* The number value supplied for `vm_node_count` must be greater than or equal to 2 and less than or equal to 5

The module will provide all other resources necessary for an Active/Active configuration.

Variables may be supplied for this example to deploy the root module in the active/active configuration. The configuration below serves as an independent reference for the same.

```hcl
provider "azurerm" {
  features {}
}

module "tfe" {
  source = "git@github.com:hashicorp/terraform-azurerm-terraform-enterprise.git"

  friendly_name_prefix = "<Friendly name to use for resources>"
  tfe_license_secret_name = "<Secret name of existing Base64 encoded TFE license in Key Vault>"

  resource_group_name = "<Existing Azure Resource Group to build TFE environment within>"

  domain_name   = "<Domain name used to determine existing DNS zone>"
  tfe_subdomain = "<Desired DNS record subdomain>"

  key_vault_name      = "<Existing Azure Key Vault name>"
  ca_certificate_name = "<Existing Azure Key Vault Certificate name>"

  tags = "<Map of tag values>"

  vm_node_count = 2
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
| `tfe_license_secret_name` | Secret name of existing Base64 encoded TFE license in Key Vault | string | license |
| `key_vault_name` | Name of an existing Key Vault | string | mykv |
| `ca_certificate_name` | Name of an existing Key Vault Ceritificate within `key_vault_name` | string | mycert |
| `vm_node_count` | Number of virtual machines | number | 2 |

### Optional Inputs For This Example

| Name | Description | Type | Example Value |
|------|-------------|------| ------------- |
| `location` | Azure location | string | East US |
| `resource_group_name` | Existing Azure Resource Group to build TFE environment within | string | myrg |
| `domain_name` | Name of existing DNS Zone in which a record set will be created | string | example.com |
| `tfe_subdomain` | Desired DNS record subdomain | string | tfe |
| `tags` | Map of tags to use for resources | map(string) | {} |
