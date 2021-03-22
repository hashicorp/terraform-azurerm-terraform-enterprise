# EXAMPLE: Deploying Terraform Enterprise in Active/Active mode with minimal input

## About This Example

This example serves only to demonstrate the bare minimum input currently required to create an [Active/Active](https://www.terraform.io/docs/enterprise/before-installing/reference-architecture/azure.html#active-active-implementation-mode) deployment. It creates all required resources using default values.

## How to Use This Module

To run this module with an Active/Active configuration with minimal input:
* The number value supplied for `vm_node_count` must be greater than or equal to 2 and less than or equal to 5
* A string value for `friendly_name_prefix` must be provided

The module will provide all other resources necessary for an Active/Active configuration.

Variables may be supplied for this example to deploy the root module in the active/active configuration with minimal input. The configuration below serves as an independent reference for the same.

```hcl
provider "azurerm" {
  features {}
}

module "tfe" {
  source = "git@github.com:hashicorp/espd-tfe-azure.git"

  friendly_name_prefix = "<Friendly name to use for resources>"
  tfe_license_filepath = "${path.module}/files/license.rli"
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
