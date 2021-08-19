# EXAMPLE: Deploying Terraform Enterprise in Active/Active mode with a custom image

## About This Example

This example serves as a reference for running Terraform Enterprise in Active/Active mode with a custom image. [Active/Active](https://www.terraform.io/docs/enterprise/before-installing/reference-architecture/azure.html#active-active-implementation-mode) implementation mode is an extension of the Standalone implementation mode that increases the scalability and load capacity of the Terraform Enterprise platform. The same application runs on multiple Terraform Enterprise instances utilizing the same external services in a shared model.

The './mock_resources' directory within this example contains a basic packer configuration to create a custom image. The mock resources are for testing purposes.

## How To Use This Module

To run this module with an Active/Active configuration and a custom image:
* The number value supplied for `vm_node_count` must be greater than or equal to 2 and less than or equal to 5
* A string value for `vm_image_id` must be provided

The module will provide all other resoruces necessary for an Active/Active configuration.

Variables may be supplied for this example to deploy the root module in the active/active configuration with a custom image. The configuration below serves as an independent reference for the same.

```hcl
provider "azurerm" {
  features {}
}

module "tfe" {
  source = "git@github.com:hashicorp/terraform-azurerm-terraform-enterprise.git"

  friendly_name_prefix    = "<Friendly name to use for resources>"
  tfe_license_secret_name = "<Secret name of existing Base64 encoded TFE license in Key Vault>"

  resource_group_name = "<Existing Azure Resource Group to build TFE environment within>"

  domain_name   = "<Domain name used to determine existing DNS zone>"
  tfe_subdomain = "<Desired DNS record subdomain>"

  key_vault_name   = "<Existing Azure Key Vault name>"
  certificate_name = "<Existing Azure Key Vault Certificate name>"

  tags = "<Map of tag values>"

  vm_node_count = 2

  # Existing custom image information
  vm_image_id = "<Azure Resource ID for custom image>"
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
| `vm_node_count` | Number of virtual machines | number | 2 |
| `vm_image_id` | Azure Resource ID for custom image | string | /subscriptions/[...]/images/imagename |
| `key_vault_name` | Name of an existing Key Vault | string | mykv |
| `certificate_name` | Name of an existing Key Vault Ceritificate within `key_vault_name` | string | mycert |
### Optional Inputs For This Example

| Name | Description | Type | Example Value |
|------|-------------|------| ------------- |
| `location` | Azure location | string | East US |
| `resource_group_name` | Existing Azure Resource Group to build TFE environment within | string | myrg |
| `domain_name` | Name of existing DNS Zone in which a record set will be created | string | example.com |
| `tfe_subdomain` | Desired DNS record subdomain | string | tfe |
| `tags` | Map of tags to use for resources | map(string) | {} |

## Other Considerations

The base image used for the custom image should be Ubuntu or RHEL to work with the root module as-is
