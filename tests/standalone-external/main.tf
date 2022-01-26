resource "random_string" "friendly_name" {
  length  = 4
  upper   = false
  number  = false
  special = false
}

module "secrets" {
  source = "../../fixtures/secrets"

  key_vault_id = var.key_vault_id

  tfe_license = {
    name = "tfe-license-${local.friendly_name_prefix}"
    path = var.license_file
  }
}

module "standalone_external" {
  source = "../../"

  domain_name             = "team-private-terraform-enterprise.azure.ptfedev.com"
  friendly_name_prefix    = local.friendly_name_prefix
  location                = "Central US"
  resource_group_name_dns = "ptfedev-com-dns-tls"

  # Bootstrapping resources
  load_balancer_certificate = data.azurerm_key_vault_certificate.load_balancer
  tfe_license_secret        = module.secrets.tfe_license
  vm_certificate_secret     = data.azurerm_key_vault_secret.vm_certificate
  vm_key_secret             = data.azurerm_key_vault_secret.vm_key

  # Standalone Demo Mode Scenario
  user_data_iact_subnet_list  = ["0.0.0.0/0"]
  vm_node_count               = 1
  vm_sku                      = "Standard_D4_v3"
  vm_image_id                 = "ubuntu"
  load_balancer_public        = true
  load_balancer_type          = "application_gateway"
  user_data_installation_type = "production"
  redis_enable_authentication = false
  user_data_redis_use_tls     = false

  create_bastion = false
  tags           = local.common_tags
}
