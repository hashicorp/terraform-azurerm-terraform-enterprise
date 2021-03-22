# EXAMPLE: Terraform Enterprise Startup Persona

## About This Example
This example demonstrates how to invoke the root module in the manner
of the Startup persona.

Traits of the Startup persona include:

* Active/Active mode

* Small instance size (4 vCPUs)

* Ubuntu as the operating system

* An externally exposed network

* No proxy

* An HTTP load balancer

* TLS termination at the load balancer

* External PostgreSQL

* External Redis

* No Redis AUTH

* No Redis encryption in transit

* No Redis encryption at rest

## How to Use This Module

To accommodate the Startup persona, this example module uses the 
following implementation details:

* Uses an existing resource group for TFE which should contain an
existing DNS zone matching 'domain_name'
* Creates and uses self signed certs
* Active/Active mode
* Default instance size is 'Standard_D4_v3'
* Default image is 'ubuntu'
* Load balancer wih public endpoint
* Non SSL Redis port enabled and used
* Redis authentication false
* Redis TLS disabled

If this repository has been cloned to a workstation then the
configuration in this directory can be applied. Alternatively, the
following HCL sample demonstrates how to invoke the root module in the
manner of the Startup persona:

```hcl
module "tfe" {
  source = "git@github.com:hashicorp/espd-tfe-azure.git"

  friendly_name_prefix = "<Friendly name to use for resources>"
  tfe_license_filepath = "<Relative local file path to TFE license>"

  resource_group_name = "<Existing Azure Resource Group to build TFE environment within>"

  domain_name   = "<Name of existing DNS Zone in which a record set will be created>"
  tfe_subdomain = "<Desired DNS record subdomain>"

  # Persona - Startup
  vm_sku                      = "Standard_D4_v3"
  vm_image_id                 = "ubuntu"
  load_balancer_public        = true
  load_balancer_type          = "load_balancer"
  redis_enable_non_ssl_port   = true
  redis_enable_authentication = false
  user_data_redis_use_tls     = false
}
```

Refer to the root module's instructions for [setup instructions](../../README.md#How-to-Use-This-Module).

Refer to the AzureRM provider article on [authentication](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs) for instructions on how to authenticate Terraform with Azure.

With authentication configured, run `terraform init` and `terraform apply` to provision the example infrastructure.

## Required Inputs

| Name | Description | Type | Example Value |
|------|-------------|------| ------------- |
| `friendly_name_prefix` | Name prefix used for resources | string | `myexample` |
| `tfe_license_path` | Local path to the TFE license | string | `./files/license.rli` |
| `resource_group_name` | Existing Azure Resource Group to build TFE environment within | string | `examplerg` |
| `domain_name` | Name of existing DNS Zone in which a record set will be created | string | `example.com` |
| `tfe_subdomain` | Desired DNS record subdomain | string | `tfe` |
