# Azure TFE Service Accounts Module

## Required variables

- `friendly_name_prefix` - string value to use as base for resource names
- `resource_group_name` - string value for Azure resource group name
- `location` - string value for Azure location

## Example usage

```hcl
module "service_accounts" {
  source = "./modules/service_accounts"

  friendly_name_prefix = var.friendly_name_prefix
  resource_group_name  = local.resource_group_name
  location             = var.location

  storage_account_tier             = var.storage_account_tier
  storage_account_replication_type = var.storage_account_replication_type

  tags = var.tags
}
```

## Resources

- [random_pet](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet)
- [azurerm_storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account)
- [azurerm_user_assigned_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/azurerm_user_assigned_identity)
- [azurerm_key_vault_access_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/azurerm_key_vault_access_policy)
