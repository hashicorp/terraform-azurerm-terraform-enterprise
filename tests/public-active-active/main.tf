resource "random_string" "friendly_name" {
  length  = 4
  upper   = false
  number  = false
  special = false
}

module "public_active_active" {
  source = "../../"

  friendly_name_prefix = local.friendly_name_prefix

  # Bootstrapping resources
  resource_group_name_kv         = var.resource_group_name_kv
  key_vault_name                 = var.key_vault_name
  resource_group_name_dns        = var.resource_group_name_dns
  domain_name                    = var.domain_name
  tfe_license_secret_name        = var.tfe_license_secret_name
  certificate_name               = var.certificate_name
  tfe_bootstrap_cert_secret_name = var.wildcard_chained_certificate_pem_secret_name
  tfe_bootstrap_key_secret_name  = var.wildcard_private_key_pem_secret_name

  # Public Active / Active Scenario
  user_data_iact_subnet_list  = var.iact_subnet_list
  vm_node_count               = 2
  vm_sku                      = "Standard_D4_v3"
  vm_image_id                 = "ubuntu"
  load_balancer_public        = true
  load_balancer_type          = "application_gateway"
  redis_enable_non_ssl_port   = true
  redis_enable_authentication = false
  user_data_redis_use_tls     = false

  tags = local.common_tags
}
