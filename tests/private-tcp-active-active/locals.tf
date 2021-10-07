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
    "${path.module}/templates/mitm.sh.tpl",
    {
      certificate_secret_id = data.azurerm_key_vault_secret.ca_certificate.id
      key_secret_id         = data.azurerm_key_vault_secret.ca_key.id
      http_proxy_port       = local.proxy_port
    }
  )

  friendly_name_prefix      = random_string.friendly_name.id
  resource_group_name       = module.private_tcp_active_active.resource_group_name
  proxy_user                = "proxyuser"
  proxy_port                = "3128"
  network_proxy_subnet_cidr = "10.0.80.0/20"
}
