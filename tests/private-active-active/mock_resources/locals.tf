locals {
  proxy_script = templatefile(
    "${path.module}/files/proxy.sh.tpl",
    {
      http_proxy_port = var.proxy_port
    }
  )

  friendly_name_prefix = random_string.friendly_name.id
  resource_group_name  = azurerm_resource_group.main.name
  location             = azurerm_resource_group.main.location
  proxy_user           = "proxyuser"
}