# Azure TFE Bastion Module

[Azure Bastion](https://docs.microsoft.com/en-us/azure/bastion/bastion-overview) is used in this module to connect to the TFE instance. Additional information on connecting to a Linux instance using SSH through Azure Bastion is available [here](https://docs.microsoft.com/en-us/azure/bastion/bastion-connect-vm-ssh).

## Required variables

* `friendly_name_prefix` - string value to use as base for resource names
* `resource_group_name` - string value for Azure resource group name
* `location` - string value for Azure location
* `bastion_subnet_id` - string value for the Azure virtual network subnet ID

## Example usage

```hcl
module "bastion" {
  source = "./modules/bastion"

  friendly_name_prefix = var.friendly_name_prefix
  resource_group_name  = local.resource_group_name
  location             = var.location

  bastion_subnet_id = local.network_public_subnet_id
}
```

## Resources

* [azurerm_public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip)
* [azurerm_bastion_host](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/bastion_host)
