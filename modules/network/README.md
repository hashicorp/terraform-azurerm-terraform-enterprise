# Azure TFE Network Module

## Required variables

* `friendly_name_prefix` - string value to use as base for resource names
* `resource_group_name` - string value for Azure resource group name
* `location` - string value for Azure location
* `network_cidr` - string value for the Azure virtual network CIDR range
* `network_private_subnet_cidr` - string value for the Azure virtual network private subnet CIDR range
* `network_public_subnet_cidr` - string value for the Azure virtual network public subnet CIDR range

## Example usage

```hcl
module "network" {
  source = "./modules/network"

  friendly_name_prefix = var.friendly_name_prefix
  resource_group_name  = local.resource_group_name
  location             = var.location

  network_cidr                = var.network_cidr
  network_private_subnet_cidr = var.network_private_subnet_cidr
  network_public_subnet_cidr  = var.network_public_subnet_cidr
}
```

## Resources

* [azurerm_virtual_network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network)
* [azurerm_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet)
* [azurerm_network_security_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group)
* [azurerm_subnet_network_security_group_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association)
