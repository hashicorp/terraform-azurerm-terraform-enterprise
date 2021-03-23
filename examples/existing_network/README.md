# EXAMPLE: Deploying Terraform Enterprise in Active/Active mode with an existing network

## About This Example

This example serves as a reference for running Terraform Enterprise in Active/Active mode with an existing network. [Active/Active](https://www.terraform.io/docs/enterprise/before-installing/reference-architecture/azure.html#active-active-implementation-mode) implementation mode is an extension of the Standalone implementation mode that increases the scalability and load capacity of the Terraform Enterprise platform. The same application runs on multiple Terraform Enterprise instances utilizing the same external services in a shared model.

The './mock_resources' directory within this example uses the existing 'network' module to create the 'existing network'. The mock resources are for testing purposes.

## How To Use This Module

To run this module with an Active/Active configuration and an existing network:
* The number value supplied for `vm_node_count` must be greater than or equal to 2 and less than or equal to 5
* The string values for existing network resources must be provided

The module will provide all other resoruces necessary for an Active/Active configuration.

Variables may be supplied for this example to deploy the root module in the active/active configuration with an existing network. The configuration below serves as an independent reference for the same.

```hcl
provider "azurerm" {
  features {}
}

module "tfe" {
  source = "git@github.com:hashicorp/espd-tfe-azure.git"

  friendly_name_prefix = "<Friendly name to use for resources>"
  tfe_license_filepath = "${path.module}/files/license.rli"

  resource_group_name = "<Existing Azure Resource Group to build TFE environment within>"

  domain_name   = "<Domain name used to determine existing DNS zone>"
  tfe_subdomain = "<Desired DNS record subdomain>"

  key_vault_name   = "<Existing Azure Key Vault name>"
  certificate_name = "<Existing Azure Key Vault Certificate name>"

  tags = "<Map of tag values>"

  vm_node_count = 2

  # Existing network information
  network_id                  = "<Virtual network resource id>"
  network_private_subnet_id   = "<Private subnet resource id>"
  network_bastion_subnet_id   = "<Bastion subnet resource id>"
  network_frontend_subnet_id  = "<Public subnet resource id>"
  network_redis_subnet_id     = "<Redis subnet resource id>"
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
| `network_id` | Name of the proxy CA certificate bundle | string | `/subscription/resource/id` |
| `network_private_subnet_id` | Azure resource ID for an existing private subnet | string | `/subscription/resource/id` |
| `network_bastion` | Azure resource ID for an existing bastion subnet | string | `/subscription/resource/id` |
| `network_public` | Azure resource ID for an existing public subnet | string | `/subscription/resource/id` |
| `network_redis` | Azure resource ID for an existing redis subnet | string | `/subscription/resource/id` |

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

## Other Considerations

The following are required for the existing network to function properly with TFE.

The private subnet must allow:

* Inbound SSH from Bastion subnet
* Inbound 443 from Public subnet
* Inbound 8800 from Public subnet (if deploying standalone)
* Inbound 65200-65535 from Public subnet for Application Gateway

The public subnet must allow:

* Inbound 443 from desired source IP range
* Inbound 8800 from desired source IP range (if deploying standalone)
* Inbound 65200-65535 from 'GatewayManager'

The bastion subnet must:

* Be in a dedicated subnet that contains no security group association as it is managed by Azure
* Be named 'AzureBastionSubnet'

The Redis subnet must:

* Be in a dedicated subnet that contains no other resources except for Azure Cache for Redis instances
