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
  resource_group_name_kv  = var.resource_group_name_kv
  key_vault_name          = var.key_vault_name
  tfe_license_secret_name = var.tfe_license_secret_name

  certificate_name            = var.certificate_name
  iact_subnet_list            = var.iact_subnet_list
  vm_node_count               = 2
  vm_sku                      = "Standard_D4_v3"
  vm_image_id                 = "ubuntu"
  load_balancer_public        = true
  load_balancer_type          = "load_balancer"
  redis_enable_non_ssl_port   = true
  redis_enable_authentication = false
  user_data_redis_use_tls     = false

  tags = local.common_tags
}
