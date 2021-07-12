# Azure TFE Key Vault Module

## Required variables

* `friendly_name_prefix` - string value to use as base for resource names
* `resource_group_name` - string value for Azure resource group name
* `location` - string value for Azure location

## Example usage

```hcl
module "key_vault" {
  source = "./modules/key_vault"

  friendly_name_prefix   = var.friendly_name_prefix
  resource_group_name    = local.resource_group_name
  resource_group_name_kv = local.resource_group_name_kv
  location               = var.location

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azurerm_client_config.current.object_id

  fqdn               = local.fqdn
  key_vault_name     = var.key_vault_name
  certificate_name   = var.certificate_name
  user_data_ca       = var.user_data_ca
  user_data_cert     = var.user_data_cert
  user_data_cert_key = var.user_data_cert_key
  load_balancer_type = var.load_balancer_type

  tags = var.tags
}
```

## Resources

* [tls_private_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key)
* [tls_self_signed_cert](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/self_signed_cert)
* [tls_cert_request](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/cert_request)
* [tls_locally_signed_cert](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/locally_signed_cert)
* [azurerm_key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault)
* [azurerm_key_vault_certificate](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_certificate)
