# Azure TFE Load Balancer Module

## Required variables

* `friendly_name_prefix` - string value to use as base for resource names
* `resource_group_name` - string value for Azure resource group name
* `location` - string value for Azure location
* `tfe_pip_id` - string value for Azure resource ID of public IP
* `network_public_subnet_id` - string value for Azure resource ID of public subnet

## Example usage

```hcl
module "load_balancer" {
  source = "./modules/load_balancer"

  friendly_name_prefix = var.friendly_name_prefix
  resource_group_name  = local.resource_group_name
  location             = var.location
  zones                = var.zones

  # General
  tfe_pip_id              = azurerm_public_ip.tfe_pip.id

  # Network
  network_public_subnet_id = local.network_public_subnet_id

  # Load balancer
  load_balancer_type                         = "load_balancer"
  load_balancer_public                       = true
}
```

## Considerations

Application Gateway requires public IP config. However, if load_balancer_public is false, the public IP will not be assigned to any listeners.

## Resources

* [azurerm_dns_a_record](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_a_record)
* [azurerm_user_assigned_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity)
* [azurerm_key_vault_access_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy)
* [azurerm_application_gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway)
* [azurerm_lb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb)
* [azurerm_lb_backend_address_pool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_backend_address_pool)
* [azurerm_lb_probe](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_probe)
* [azurerm_lb_rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_rule)
