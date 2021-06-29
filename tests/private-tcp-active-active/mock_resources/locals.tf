locals {
  proxy_script = templatefile(
    "${path.module}/files/mitm.sh.tpl",
    {
      http_proxy_port = local.proxy_port
      # CHANGE THIS SO THAT IT GRABS THEM FROM KEY VAULT
      // certificate     = tls_self_signed_cert.ca.cert_pem
      // private_key     = tls_private_key.ca.private_key_pem
    }
  )

  friendly_name_prefix = random_string.friendly_name.id
  resource_group_name  = azurerm_resource_group.main.name
  location             = azurerm_resource_group.main.location
  proxy_user           = "proxyuser"
  proxy_port           = "3128"
}