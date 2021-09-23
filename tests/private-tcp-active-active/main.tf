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
  ca_cert_secret_name            = var.ca_cert_secret_name
  key_vault_name                 = var.key_vault_name
  resource_group_name_kv         = var.resource_group_name_kv
  tfe_bootstrap_cert_secret_name = var.wildcard_chained_certificate_pem_secret_name
  tfe_bootstrap_key_secret_name  = var.wildcard_private_key_pem_secret_name
  tfe_license_secret_name        = var.tfe_license_secret_name

  # Behind proxy information
  proxy_ip   = azurerm_linux_virtual_machine.proxy.private_ip_address
  proxy_port = local.proxy_port

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

  create_bastion              = false
  network_bastion_subnet_cidr = azurerm_subnet.vm_bastion.address_prefixes[0]
  tags                        = local.common_tags
}
