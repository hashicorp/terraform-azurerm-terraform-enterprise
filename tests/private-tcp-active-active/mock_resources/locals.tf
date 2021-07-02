locals {
  proxy_script = templatefile(
    "${path.module}/files/mitm.sh.tpl",
    {
      http_proxy_port        = local.proxy_port
      key_vault_name         = var.key_vault_name
      proxy_key_secret_name  = var.proxy_key_secret_name
      proxy_cert_secret_name = var.proxy_cert_secret_name
    }
  )

  friendly_name_prefix = random_string.friendly_name.id
  resource_group_name  = azurerm_resource_group.main.name
  location             = azurerm_resource_group.main.location
  proxy_user           = "proxyuser"
  proxy_port           = "3128"
}