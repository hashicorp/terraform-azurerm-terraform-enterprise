provider "azurerm" {
  features {}
}

resource "random_string" "friendly_name" {
  length  = 4
  upper   = false
  number  = false
  special = false
}

module "private_tcp_active_active" {
  source = "../../"

  location             = var.location
  friendly_name_prefix = local.friendly_name_prefix
  tfe_license_name     = "terraform-azurerm-terraform-enterprise.rli"

  resource_group_name_dns = var.resource_group_name_dns

  domain_name   = var.domain_name

  # Bootstrapping resources
  bootstrap_storage_account_name           = var.bootstrap_storage_account_name
  bootstrap_storage_account_container_name = var.bootstrap_storage_account_container_name
  resource_group_name_bootstrap            = var.resource_group_name_bootstrap
  resource_group_name_kv                   = var.resource_group_name_kv
  key_vault_name                           = local.key_vault_name
  user_data_ca                             = local.user_data_ca
  user_data_cert                           = local.user_data_cert
  user_data_cert_key                       = local.user_data_cert_key

  tags = local.common_tags

  # Behind proxy information
  proxy_ip               = azurerm_linux_virtual_machine.proxy.private_ip_address
  proxy_port             = local.proxy_port
  proxy_cert_name        = var.proxy_cert_name
  proxy_cert_secret_name = var.proxy_cert_secret_name

  # Private Active / Active Scenario
  vm_node_count               = 2
  vm_sku                      = "Standard_D32a_v4"
  vm_image_id                 = "rhel"
  load_balancer_public        = false
  load_balancer_type          = "load_balancer"
  redis_enable_non_ssl_port   = false
  redis_enable_authentication = true
  user_data_redis_use_tls     = true
  redis_rdb_backup_enabled    = true
  redis_rdb_backup_frequency  = 60

  create_bastion = false
}
