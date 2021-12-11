# FIXTURE: TFE Bastion Virtual Machine Module

While the root module of this repository gives you the option to create an [Azure Bastion](../modules/bastion/README.md) (as this is the recommended method for accessing your TFE instance), there may be times for development environments when you will need SSH access to the bastion host. This module will create a virtual machine that you will be able to use as a bastion host for your TFE instance. This is not recommended for production environments.

## Example usage

```hcl
module "secrets" {
  source = "./fixtures/secrets"

  key_vault_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-tfe-rg/providers/Microsoft.KeyVault/vaults/my-tfe-kv"
}
```

## Resources

* [azurerm_key_vault_secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret)
