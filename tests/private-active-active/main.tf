resource "random_string" "friendly_name" {
  length  = 4
  upper   = false
  number  = false
  special = false
}

module "private_active_active" {
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


  # Behind proxy information
  proxy_ip   = azurerm_linux_virtual_machine.proxy.private_ip_address
  proxy_port = local.proxy_port

  # Private Active / Active Scenario
  user_data_iact_subnet_list  = ["${azurerm_linux_virtual_machine.vm_bastion.private_ip_address}/32"]
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
