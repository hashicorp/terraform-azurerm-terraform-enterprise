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

  resource_group_name_dns    = var.resource_group_name_dns
  domain_name                = var.domain_name
  user_data_iact_subnet_list = ["${azurerm_linux_virtual_machine.vm_bastion.private_ip_address}/32"]

  # Bootstrapping resources
  tfe_license_secret    = data.azurerm_key_vault_secret.tfe_license
  vm_certificate_secret = data.azurerm_key_vault_secret.vm_certificate
  vm_key_secret         = data.azurerm_key_vault_secret.vm_key

  # Behind proxy information
  ca_certificate_secret = data.azurerm_key_vault_secret.ca_certificate
  proxy_ip              = azurerm_linux_virtual_machine.proxy.private_ip_address
  proxy_port            = local.proxy_port

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
  user_data_installation_type = "production"

  create_bastion = false
  tags           = local.common_tags
}
