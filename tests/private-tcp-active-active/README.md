# EXAMPLE: Terraform Enterprise Bank Persona

## About This Example
This example demonstrates how to invoke the root module in the manner
of the Bank persona

Traits of the Bank persona include:

* Active/Active mode

* Large instance size (32 vCPUs)

* RHEL as the operating system

* SELinux enabled

* An internally exposed network

* MITM proxy

* TCP load balancer

* End to end TLS

* External PostgreSQL

* External Redis

* Redis authentication enabled

* Redis encryption in transit

* Redis encryption at rest

# How to Use This Module

To accommodate the Bank persona, this example module uses the
following implementation details:

* Uses an existing resource group for TFE which should contain an
existing DNS zone matching 'domain_name'
* Creates and uses a self signed certificate for TFE, adding trust
to the Azure Load Balancer
* Active/Active mode
* Instance size of 'Standard_D32a_v4'
* Image of 'rhel'
* Azure Load Balancer
* Redis uses SSL port only
* Redis authentication true
* Redis TLS enabled
* Redis data persistence and encryption at rest enabled

If this repository has been cloned to a workstation then the
configuration in this directory can be applied. Alternatively, the
following HCL sample demonstrates how to invoke the root module in the
manner of the Bank persona without proxy (to include proxy, add the 
rest of the configuration in [`examples/persona_bank/main.tf`)](./main.tf):

```hcl
module "tfe" {
  source = "git@github.com:hashicorp/espd-tfe-azure.git"

  friendly_name_prefix = "<Friendly name to use for resources>"
  tfe_license_filepath = "<Relative local file path to TFE license>"

  resource_group_name = "<Existing Azure Resource Group to build TFE environment within>"

  domain_name   = "<Name of existing DNS Zone in which a record set will be created>"
  tfe_subdomain = "<Desired DNS record subdomain>"

  # Persona - Bank
  vm_sku                                       = "Standard_D32a_v4"
  vm_image_id                                  = "rhel"
  load_balancer_public                         = false
  load_balancer_type                           = "load_balancer"
  redis_enable_non_ssl_port                    = false
  redis_enable_authentication                  = true
  user_data_redis_use_tls                      = true
  storage_account_tier                         = "Premium"
  storage_account_replication_type             = "LRS"
  redis_rdb_backup_enabled                     = true
  redis_rdb_backup_frequency                   = 60
}
```

If you would like to use the proxy in the example, then please run everything included in the entire [main.tf](./main.tf) in your provisioning and set the variables accordingly in a `terraform.tfvars` file like the one included as an [example](./terraform.tfvars.example). For testing purposes, you may add a bastion host virtual machine to employ as a jumpbox to test your deployment locally. See the nested [`mock_resources`](./mock_resources) module for more details.

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


## Required Inputs For This Example

| Name | Description | Type | Example Value |
|------|-------------|------| ------------- |
| `friendly_name_prefix` | Name prefix used for resources | string | `myexample` |
| `tfe_license_path` | Local path to the TFE license | string | `./files/license.rli` |
| `domain_name` | Name of existing DNS Zone in which a record set will be created | string | `example.com` |
| `tfe_subdomain` | Desired DNS record subdomain | string | `tfe` |
| `network_id` | Existing network ID | string | `/subscriptions/12345-subscription-id/resourceGroups/bank-rg/providers/Microsoft.Network/virtualNetworks/bank-network` |
| `network_private_subnet_id` | Existing network private subnet ID | string | `/subscriptions/12345-subscription-id/resourceGroups/bank-rg/providers/Microsoft.Network/virtualNetworks/bank-network/subnets/bank-private-subnet` |
| `network_frontend_subnet_id` | Existing network public subnet ID | string | `/subscriptions/12345-subscription-id/resourceGroups/bank-rg/providers/Microsoft.Network/virtualNetworks/bank-network/subnets/bank-frontend-subnet` |
| `network_redis_subnet_id` | Existing network Redis subnet ID | string | `/subscriptions/12345-subscription-id/resourceGroups/bank-rg/providers/Microsoft.Network/virtualNetworks/bank-network/subnets/bank-redis-subnet` |
| `redis_rdb_existing_storage_account` | Name of an existing Premium Storage Account for data encryption at rest. If empty string is given, a new, Premium storage account will be created. | `redisstorage` |
| `redis_rdb_existing_storage_account_rg` | Name of the resource group that contains the existing Premium Storage Account for data encryption at rest. | `redis-sa-rg` |
| `proxy_ip` | IP Address of the proxy server | string | `10.0.64.4` |
| `proxy_port` | Port used for proxy string | `3128` |
| `proxy_cert_path` | Local path to the proxy's CA cert pem | string | `/path/to/cert.pem` |

### Optional Inputs For This Example

| Name | Description | Type | Example Value |
|------|-------------|------| ------------- |
| `location` | Azure location | string | `East US` |
| `resource_group_name` | Existing Azure Resource Group to build TFE environment within | string | `myrg` |
| `resource_group_name_dns` | Existing Azure Resource Group which contains DNS zone | string | `dnsrg` |
| `proxy_cert_name` | Name of proxy cert | string | `mitmproxy` |
| `tags` | Map of tags to use for resources | map(string) | `{}` |