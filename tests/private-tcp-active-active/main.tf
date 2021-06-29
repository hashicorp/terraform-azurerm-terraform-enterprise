provider "azurerm" {
  features {}
}

module "mock_resources" {
  source = "./mock_resources"
  tags   = local.common_tags
}

module "private_tcp_active_active" {
  source = "../../"

  location             = module.mock_resources.location
  friendly_name_prefix = local.friendly_name_prefix
  tfe_license_name     = "terraform-azurerm-terraform-enterprise.rli"

  resource_group_name     = module.mock_resources.resource_group_name
  resource_group_name_dns = var.resource_group_name_dns

  domain_name   = var.domain_name
  tfe_subdomain = local.friendly_name_prefix

  bootstrap_storage_account_name           = var.bootstrap_storage_account_name
  bootstrap_storage_account_container_name = var.bootstrap_storage_account_container_name
  resource_group_name_bootstrap            = var.resource_group_name_bootstrap

  tags = local.common_tags

  vm_node_count = 2

  # Behind proxy information
  proxy_ip        = module.mock_resources.host_private_ip
  proxy_port      = module.mock_resources.proxy_port
  proxy_cert_name = var.proxy_cert_name
  proxy_cert_path = var.proxy_cert_path

  # Existing network information
  network_id                 = module.mock_resources.network_id
  network_private_subnet_id  = module.mock_resources.network_private_subnet_id
  network_frontend_subnet_id = module.mock_resources.network_frontend_subnet_id
  network_redis_subnet_id    = module.mock_resources.network_redis_subnet_id

  # Persona - Bank
  vm_sku                                = "Standard_D32a_v4"
  vm_image_id                           = "rhel"
  load_balancer_public                  = false
  load_balancer_type                    = "load_balancer"
  redis_enable_non_ssl_port             = false
  redis_enable_authentication           = true
  user_data_redis_use_tls               = true
  redis_rdb_backup_enabled              = true
  redis_rdb_backup_frequency            = 60

  # Change this logic so that it doesn't use an empty string
  redis_rdb_existing_storage_account    = var.redis_rdb_existing_storage_account
  redis_rdb_existing_storage_account_rg = var.redis_rdb_existing_storage_account_rg

  create_bastion = false

  depends_on = [module.mock_resources]
}
