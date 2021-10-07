# Azure TFE Object Storage Module

## Required variables

* `friendly_name_prefix` - string value to use as base for resource names
* `resource_group_name` - string value for Azure resource group name
* `location` - string value for Azure location
* `storage_account_name` string value for storage account name

## Example usage

```hcl
module "object_storage" {
  source = "./modules/object_storage"
  count  = var.storage_account_container_name == null ? 1 : 0

  friendly_name_prefix = var.friendly_name_prefix
  resource_group_name  = module.resource_groups.resource_group_name
  location             = var.location

  # Application storage
  storage_account_name                           = var.storage_account_name
  storage_account_container_name                 = var.storage_account_container_name
  storage_account_key                            = var.storage_account_key
  storage_account_primary_blob_connection_string = var.storage_account_primary_blob_connection_string
  storage_account_tier                           = var.storage_account_tier
  storage_account_replication_type               = var.storage_account_replication_type

  tags = var.tags
}
```

## Resources

* [azurerm_storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account)
* [azurerm_storage_container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container)
* [random_pet](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet)
