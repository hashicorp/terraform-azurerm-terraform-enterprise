locals {
  common_tags = {
    Terraform   = "cloud"
    Environment = "${local.friendly_name_prefix}-test-private-active-active"
    Description = "Private Active/Active"
    Repository  = "hashicorp/terraform-azurerm-terraform-enterprise"
    Team        = "Terraform Enterprise on Prem"
    OkToDelete  = "True"
  }

  proxy_script = templatefile(
    "${path.module}/files/squidproxy.sh.tpl",
    {
      http_proxy_port = local.proxy_port
    }
  )

  friendly_name_prefix = random_string.friendly_name.id
  resource_group_name  = module.private_active_active.resource_group_name
  key_vault_name       = data.azurerm_key_vault.kv.name
  proxy_user           = "proxyuser"
  proxy_port           = "3128"
}
