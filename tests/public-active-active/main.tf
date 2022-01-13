resource "random_string" "friendly_name" {
  length  = 4
  upper   = false
  number  = false
  special = false
}

module "public_active_active" {
  source = "../../"

  domain_name             = var.domain_name
  friendly_name_prefix    = local.friendly_name_prefix
  location                = var.location
  resource_group_name_dns = var.resource_group_name_dns

  # Bootstrapping resources
  load_balancer_certificate = data.azurerm_key_vault_certificate.load_balancer
  tfe_license_secret        = data.azurerm_key_vault_secret.tfe_license
  vm_certificate_secret     = data.azurerm_key_vault_secret.vm_certificate
  vm_key_secret             = data.azurerm_key_vault_secret.vm_key

  # Public Active / Active Scenario
  iact_subnet_list     = var.iact_subnet_list
  vm_node_count        = 2
  vm_sku               = "Standard_D4_v3"
  vm_image_id          = "ubuntu"
  load_balancer_public = true
  load_balancer_type   = "application_gateway"
  installation_type    = "production"

  redis = {
    family                          = "P"
    sku_name                        = "Premium"
    size                            = "3"
    enable_non_ssl_port             = true
    use_password_auth               = false
    rdb_backup_enabled              = false
    rdb_backup_frequency            = null
    rdb_backup_max_snapshot_count   = null
    rdb_existing_storage_account    = null
    rdb_existing_storage_account_rg = null
    use_tls                         = false
    minimum_tls_version             = "1.2"
  }

  tags = local.common_tags
}

module "user_settings" {
  redis_enable_non_ssl_port = var.redis.enable_non_ssl_port
  redis_use_tls             = var.redis.use_tls
  redis_use_password_auth   = var.redis.use_password_auth
}