locals {
  common_tags = {
    Terraform   = "cloud"
    Environment = "${local.friendly_name_prefix}-test-private-tcp-active-active"
    Description = "Private TCP Active/Active"
    Repository  = "hashicorp/terraform-azurerm-terraform-enterprise"
    Team        = "Terraform Enterprise on Prem"
    OkToDelete  = "True"
  }

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
  resource_group_name  = module.private_tcp_active_active.resource_group_name
  proxy_user           = "proxyuser"
  proxy_port           = "3128"
  key_vault_id         = module.private_tcp_active_active.key_vault_id
  user_data_ca         = data.azurerm_key_vault_secret.user_data_ca.value
  user_data_cert       = data.azurerm_key_vault_secret.user_data_cert.value
  user_data_cert_key   = data.azurerm_key_vault_secret.user_data_cert_key.value
}