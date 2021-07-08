provider "azurerm" {
  features {}
}

resource "random_string" "friendly_name" {
  length  = 4
  upper   = false
  number  = false
  special = false
}

module "private_active_active" {
  source = "../../"

  location             = var.location
  friendly_name_prefix = local.friendly_name_prefix
  tfe_license_name     = "terraform-azurerm-terraform-enterprise.rli"

  resource_group_name_dns = var.resource_group_name_dns
  domain_name             = var.domain_name

  resource_group_name_kv = var.resource_group_name_kv
  key_vault_name         = local.key_vault_name
  certificate_name       = var.certificate_name

  bootstrap_storage_account_name           = var.bootstrap_storage_account_name
  bootstrap_storage_account_container_name = var.bootstrap_storage_account_container_name
  resource_group_name_bootstrap            = var.resource_group_name_bootstrap

  # Behind proxy information
  proxy_ip               = azurerm_linux_virtual_machine.proxy.private_ip_address
  proxy_port             = local.proxy_port

  # Private Active / Active Scenario
  vm_node_count               = 2
  vm_sku                      = "Standard_D16as_v4"
  vm_image_id                 = "rhel"
  load_balancer_public        = false
  load_balancer_type          = "application_gateway"
  load_balancer_sku_name      = "WAF_v2"
  load_balancer_sku_tier      = "WAF_v2"
  redis_enable_non_ssl_port   = true
  redis_enable_authentication = true
  user_data_redis_use_tls     = false

  create_bastion = false
  tags           = local.common_tags
}
