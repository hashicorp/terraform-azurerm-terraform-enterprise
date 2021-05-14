# EXAMPLE: Deploying Terraform Enterprise in Active/Active Mode

## About This Example

[Active/Active](https://www.terraform.io/docs/enterprise/before-installing/reference-architecture/azure.html#active-active-implementation-mode) implementation mode is an extension of the Standalone implementation mode that increases the scalability and load capacity of the Terraform Enterprise platform. The same application runs on multiple Terraform Enterprise instances utilizing the same external services in a shared model.

## Airgap Installation Method

This example requires you to download replicated and the airgap file before running this example.

There are some helper bash scripts in the [files/](../../files/) directory


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
  source = "git@github.com:hashicorp/espd-tfe-azure.git"

  friendly_name_prefix = "<Friendly name to use for resources>"
  tfe_license_filepath = "${path.module}/files/license.rli"

  tfe_airgap_file_paths = {
    replicated_blob = "../../files/replicated-2.51.3.tar.gz"
    tfe_blob        = "../../files/v202104-1(528).airgap"
  }

  installation_mode = "airgap"

  resource_group_name = "<Existing Azure Resource Group to build TFE environment within>"

  domain_name   = "<Domain name used to determine existing DNS zone>"
  tfe_subdomain = "<Desired DNS record subdomain>"

  key_vault_name   = "<Existing Azure Key Vault name>"
  certificate_name = "<Existing Azure Key Vault Certificate name>"

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
| `tfe_license_path` | Local path to the TFE license | string | /files/license.rli |
| `vm_node_count` | Number of virtual machines | number | 2 |

### Optional Inputs For This Example

| Name | Description | Type | Example Value |
|------|-------------|------| ------------- |
| `location` | Azure location | string | East US |
| `resource_group_name` | Existing Azure Resource Group to build TFE environment within | string | myrg |
| `domain_name` | Name of existing DNS Zone in which a record set will be created | string | example.com |
| `tfe_subdomain` | Desired DNS record subdomain | string | tfe |
| `key_vault_name` | Name of an existing Key Vault | string | mykv |
| `certificate_name` | Name of an existing Key Vault Ceritificate within `key_vault_name` | string | mycert |
| `tags` | Map of tags to use for resources | map(string) | {} |
