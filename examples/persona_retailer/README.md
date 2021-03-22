# EXAMPLE: Terraform Enterprise Retailer Persona

## About This Example
This example demonstrates how to invoke the root module in the manner
of the Retailer persona

Traits of the Retailer persona include:

* Active/Active mode

* Large instance size (16 vCPUs)

* RHEL as the operating system

* An internally exposed network

* A proxy without TLS termination

* An Application Gateway

* End to end TLS

* External PostgreSQL

* External Redis

* Redis authentication enabled

* No Redis encryption in transit

* No Redis encryption at rest

# How to Use This Module

To accommodate the Retailer persona, this example module uses the
following implementation details:

* Uses an existing resource group for TFE which should contain an
existing DNS zone matching 'domain_name' and an existing network
* Uses an existing Azure Key Vault and Azure Key Vault Certificate
for the Application Gateway
* Creates and uses a self signed certificate for TFE, adding trust
to the Application Gateway
* Active/Active mode
* Instance size of 'Standard_D16as_v4'
* Image of 'rhel'
* Application Gateway with no listener configure for public access
* Non SSL Redis port enabled and used
* Redis authentication true
* Redis TLS disabled

If this repository has been cloned to a workstation then the
configuration in this directory can be applied. Alternatively, the
following HCL sample demonstrates how to invoke the root module in the
manner of the Bank persona:

```hcl
module "tfe" {
  source = "git@github.com:hashicorp/espd-tfe-azure.git"

  friendly_name_prefix = "<Friendly name to use for resources>"
  tfe_license_filepath = "<Relative local file path to TFE license>"

  resource_group_name = "<Existing Azure Resource Group to build TFE environment within>"

  domain_name   = "<Name of existing DNS Zone in which a record set will be created>"
  tfe_subdomain = "<Desired DNS record subdomain>"

  # Persona - Retailer
  vm_sku                      = "Standard_D16as_v4"
  vm_image_id                 = "rhel"
  load_balancer_public        = false
  load_balancer_type          = "application_gateway"
  load_balancer_sku_name      = "WAF_v2"
  load_balancer_sku_tier      = "WAF_v2"
  redis_enable_non_ssl_port   = true
  redis_enable_authentication = true
  user_data_redis_use_tls     = false
}
```

Refer to the root module's instructions for [setup instructions](../../README.md#How-to-Use-This-Module).

Refer to the AzureRM provider article on [authentication](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs) for instructions on how to authenticate Terraform with Azure.

With authentication configured, run `terraform init` and `terraform apply` to provision the example infrastructure.

### Accessing the Private Deployment via Web Browser

An SOCKS5 proxy over an SSH channel on your workstation can be used 
to access the TFE deployment from outside of the Azure network. The
following example demonstrates how to establish a SOCKS5 proxy using
Bash, an bastion host virtual machine, and an internet browser.

First, establish the SOCKS5 proxy. The following command creates a
proxy listening to port 5000 and bound to localhost which forwards
traffic through one of the compute instances in the TFE delpoyment.
Be sure to change the values in between `< >`:

```bash
$ ssh -N -p 22 -D localhost:5000 <bastionuser>@<bastion-vm.fqdn.com> -i /path/to/id_rsa
```

Second, a web browser or the operating system must be configured to use
the SOCKS5 proxy. The instructions to accomplish this vary depending on
the browser or operating system in use, but in Firefox, this can be
configured in:

> Preferences > Network Settings > Manual proxy configuration >
SOCKS: Host; Port

Third, the URL from the login_url Terraform output can be accessed
through the browser to start using the deployment. It is expected that
the browser will issue an untrusted certificate warning as this example
attaches a self-signed certificate to the internal load balancer.

## Required Inputs

| Name | Description | Type | Example Value |
|------|-------------|------| ------------- |
| `friendly_name_prefix` | Name prefix used for resources | string | `myexample` |
| `tfe_license_path` | Local path to the TFE license | string | `./files/license.rli` |
| `resource_group_name` | Existing Azure Resource Group to build TFE environment within | string | `examplerg` |
| `domain_name` | Name of existing DNS Zone in which a record set will be created | string | `example.com` |
| `tfe_subdomain` | Desired DNS record subdomain | string | `tfe` |
