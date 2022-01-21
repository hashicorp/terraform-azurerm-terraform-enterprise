# FIXTURE: TFE Bastion Virtual Machine Module

While the root module of this repository gives you the option to create an
[Azure Bastion](../modules/bastion/README.md) (as this is the recommended method
for accessing your TFE instance), there may be times for development environments
when you will need SSH access to the bastion host (which the Azure Bastion does
not provide). This module will create a virtual machine that you will be able to
use as a bastion host for your TFE instance.

**NOTE: This is not recommended for production environments.**

## Example usage

```hcl
module "bastion_vm" {
  source               = "../../fixtures/bastion_vm"
  friendly_name_prefix = local.friendly_name_prefix

  location             = var.location
  resource_group_name  = local.resource_group_name
  virtual_network_name = module.private_active_active.network.network.name
  network_allow_range  = var.network_allow_range
  bastion_subnet_cidr  = "10.0.16.0/20"
  ssh_public_key       = data.azurerm_key_vault_secret.bastion_public_ssh_key.value
  source_port_range    = "*"
  bastion_user         = "bastionuser"

  tags                 = local.common_tags
}
```

## Resources

* [azurerm_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet)
* [azurerm_public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip)
* [azurerm_network_interface](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface)
* [azurerm_network_security_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group)
* [azurerm_network_interface_security_group_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association)
* [azurerm_linux_virtual_machine](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine)