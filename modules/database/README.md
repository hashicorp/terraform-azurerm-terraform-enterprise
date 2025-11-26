# Azure TFE Database Module

## Required variables

* `friendly_name_prefix` - string value to use as base for resource names
* `resource_group_name` - string value for Azure resource group name
* `location` - string value for Azure location
* `database_subnet` - string value for the Azure virtual network subnet ID

## Example usage

```hcl
module "database" {
  source = "./modules/database"

  friendly_name_prefix = var.friendly_name_prefix
  resource_group_name  = local.resource_group_name
  location             = var.location

  database_user         = var.database_user
  database_machine_type = var.database_machine_type
  database_size_mb      = var.database_size_mb
  database_version      = var.database_version
  database_subnet       = local.network_private_subnet_id
}
```

## Resources

* [random_string](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string)
* [azurerm_postgresql_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_server)
* [azurerm_postgresql_database](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_database)
* [azurerm_postgresql_virtual_network_rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_virtual_network_rule)
