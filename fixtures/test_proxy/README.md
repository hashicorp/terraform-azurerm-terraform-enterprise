# FIXTURE: TFE Test Proxy Module

This module creates mitmproxy servers and Squid servers for use in
test modules.

## Example usage

```hcl
module "test_proxy" {
  source               = "../../fixtures/test_proxy"
  friendly_name_prefix = local.friendly_name_prefix

  location                         = var.location
  resource_group_name              = local.resource_group_name
  virtual_network_name             = module.private_tcp_active_active.network.network.name
  proxy_subnet_cidr                = local.network_proxy_subnet_cidr
  proxy_user                       = local.proxy_user
  proxy_public_ssh_key_secret_name = data.azurerm_key_vault_secret.proxy_public_ssh_key.value
  key_vault_id                     = var.key_vault_id
  mitmproxy_ca_certificate_secret  = data.azurerm_key_vault_secret.ca_certificate.id
  mitmproxy_ca_private_key_secret  = data.azurerm_key_vault_secret.ca_key.id

  tags = local.common_tags

}
```

## Resources

- [azurerm_linux_virtual_machine] https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine
- [network_security_group] https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group
- [azurerm_subnet] https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group
- [azurerm_user_assigned_identity] https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity