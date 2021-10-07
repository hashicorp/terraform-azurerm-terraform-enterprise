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

  tfe_license_name        = var.tfe_license_name
  tfe_license_secret_name = "<Secret name of existing Base64 encoded TFE license in Key Vault>"

  storage_account_name             = local.storage_account_name
  storage_account_tier             = var.storage_account_tier
  storage_account_replication_type = var.storage_account_replication_type

  tags = var.tags
}
```

## Resources

* [azurerm_storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account)
* [azurerm_storage_container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container)
* [random_pet](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet)
