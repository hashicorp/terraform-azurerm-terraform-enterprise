locals {
  proxy_script = templatefile(
    "${path.module}/files/mitm.sh.tpl",
    {
      http_proxy_port        = local.proxy_port
      bootstrap_storage_account_name = var.bootstrap_storage_account_name
      bootstrap_storage_account_container_name = var.bootstrap_storage_account_container_name
      proxy_cert_bundle_blob = var.proxy_cert_bundle_blob
    }
  )

  friendly_name_prefix = random_string.friendly_name.id
  resource_group_name  = azurerm_resource_group.main.name
  location             = azurerm_resource_group.main.location
  proxy_user           = "proxyuser"
  proxy_port           = "3128"
}