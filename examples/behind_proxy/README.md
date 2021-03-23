# EXAMPLE: Deploying Terraform Enterprise in Active/Active mode behind a proxy

## About This Example

The purpose of this module is to serve as an example for deploying behind a proxy. [Active/Active](https://www.terraform.io/docs/enterprise/before-installing/reference-architecture/azure.html#active-active-implementation-mode) implementation mode is an extension of the Standalone implementation mode that increases the scalability and load capacity of the Terraform Enterprise platform. The same application runs on multiple Terraform Enterprise instances utilizing the same external services in a shared model.

The './mock_resources' directory within this example uses the existing 'network' module to create the 'existing network' and also creates resources necessary for a basic proxy. The mock resources are for testing purposes.

## How to Use This Module

To run this module with an Active/Active configuration behind a proxy:
* The number value supplied for `vm_node_count` must be greater than or equal to 2 and less than or equal to 5
* A string value for `proxy_ip` must be provided
* Certificates for the proxy may optionally be supplied

The module will provide all other resources necessary for an Active/Active configuration.

Variables may be supplied for this example to deploy the root module in the active/active configuration behind a proxy. The configuration below serves as an independent reference for the same.

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

  # Behind proxy information
  proxy_ip        = "<IP address of the existing proxy>"
  proxy_cert_name = "<Name of the proxy CA certificate bundle>"
  proxy_cert_path = "<Local path to the CA certificate bundle>"

  # Existing network information
  network_id                = "<Virtual network resource id>"
  network_private_subnet_id = "<Private subnet resource id>"
  network_bastion_subnet_id = "<Bastion subnet resource id>"
  network_public_subnet_id  = "<Public subnet resource id>"
  network_redis_subnet_id   = "<Redis subnet resource id>"
}
```

Refer to the root module's instructions for [setup instructions](../../README.md#How-to-Use-This-Module).

Refer to the AzureRM provider article on [authentication](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs) for instructions on how to authenticate with Azure.

With authentication configured, run `terraform init` and `terraform apply` to provision the example infrastructure.

## Required inputs

| Name | Description | Type | Example Value |
|------|-------------|------| ------------- |
| `friendly_name_prefix` | Name prefix used for resources | string | `myexample` |
| `tfe_license_path` | Local path to the TFE license | string | `./files/license.rli` |
| `proxy_ip` | IP address of the existing proxy | string | `1.2.3.4:1234` |

## Optional inputs

| Name | Description | Type | Example Value |
|------|-------------|------| ------------- |
| `location` | Azure location | string | East US |
| `resource_group_name` | Existing Azure Resource Group to build TFE environment within | string | `examplerg` |
| `domain_name` | Name of existing DNS Zone in which a record set will be created | string | `example.com` |
| `tfe_subdomain` | Desired DNS record subdomain | string | `tfe` |
| `proxy_cert_name` | Name of the proxy CA certificate bundle | string | `examplecert` |
| `proxy_cert_path` | Local path to the CA certificate bundle | string | `./files/examplecert.crt` |
| `network_id` | Name of the proxy CA certificate bundle | string | `/subscription/resource/id` |
| `network_private_subnet_id` | Azure resource ID for an existing private subnet | string | `/subscription/resource/id` |
| `network_bastion` | Azure resource ID for an existing bastion subnet | string | `/subscription/resource/id` |
| `network_public` | Azure resource ID for an existing public subnet | string | `/subscription/resource/id` |
| `network_redis` | Azure resource ID for an existing redis subnet | string | `/subscription/resource/id` |
