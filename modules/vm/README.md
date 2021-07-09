# Azure TFE VM Module

## Required variables

* `friendly_name_prefix` - string value to use as base for resource names
* `resource_group_name` - string value for Azure resource group name
* `location` - string value for Azure location
* `vm_subnet_id` - string value for Azure resource id of network subnet for vmss
* `vm_user` - string value for vm username
* `vm_public_key` - string value for vm user ssh public key

## Example usage

```hcl
module "vm" {
  source = "./modules/vm"

  friendly_name_prefix = var.friendly_name_prefix
  resource_group_name  = var.resource_group_name
  location             = var.location

  # VM
  vm_sku                  = var.vm_sku
  vm_subnet_id            = var.network_private_subnet_id
  vm_user                 = var.vm_user
  vm_public_key           = var.vm_public_key
  vm_node_count           = var.vm_node_count
}
```

## Resources

* [azurerm_linux_virtual_machine_scale_set](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine_scale_set)
* [azurerm_role_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment)
* [azurerm_virtual_machine_scale_set_extension](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_scale_set_extension)
