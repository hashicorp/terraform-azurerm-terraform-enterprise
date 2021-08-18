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
  tfe_license_secret_name = "<Existing Base64 encoded TFE license in Key Vault>"

  storage_account_name = local.storage_account_name
}
```

## Resources

* [azurerm_storage_container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container)
* [azurerm_storage_blob](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_blob)
