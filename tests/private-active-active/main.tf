provider "azurerm" {
  features {}
}

module "mock_resources" {
  source = "./mock_resources"

  friendly_name_prefix = local.friendly_name_prefix
  proxy_port           = local.proxy_port
  tags                 = local.common_tags
}

module "tfe" {
  source = "../../"

  location             = module.mock_resources.location
  friendly_name_prefix = local.friendly_name_prefix
  tfe_license_name     = "terraform-azurerm-terraform-enterprise.rli"

  resource_group_name     = module.mock_resources.resource_group_name
  resource_group_name_dns = var.resource_group_name_dns

  domain_name   = var.domain_name
  tfe_subdomain = local.friendly_name_prefix

  resource_group_name_kv = var.resource_group_name_kv
  key_vault_name         = var.key_vault_name
  certificate_name       = var.certificate_name

  bootstrap_storage_account_name           = var.bootstrap_storage_account_name
  bootstrap_storage_account_container_name = var.bootstrap_storage_account_container_name
  resource_group_name_bootstrap            = var.resource_group_name_bootstrap


  tags = local.common_tags

  vm_node_count = 2

  # Behind proxy information
  proxy_ip   = module.mock_resources.host_private_ip
  proxy_port = local.proxy_port

  # Existing network information
  network_id                 = module.mock_resources.network_id
  network_private_subnet_id  = module.mock_resources.network_private_subnet_id
  network_frontend_subnet_id = module.mock_resources.network_frontend_subnet_id
  network_redis_subnet_id    = module.mock_resources.network_redis_subnet_id

  # Private Active / Active Scenario
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
}
