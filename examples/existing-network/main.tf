resource "random_string" "friendly_name" {
  length  = 4
  upper   = false
  number  = false
  special = false
}

# Store TFE License as secret
# ---------------------------
module "secrets" {
  source = "../../fixtures/secrets"

  key_vault_id = var.key_vault_id
  tfe_license = {
    name = "tfe-license-${random_string.friendly_name.id}"
    path = var.license_file
  }
}

# TFE installation into an existing network
# -----------------------------------------
module "existing_network" {
  source = "../../"

  domain_name          = var.domain_name
  friendly_name_prefix = local.friendly_name_prefix
  location             = var.location

  # Existing network resources
  network_bastion_subnet_id            = var.network_bastion_subnet_id
  network_database_subnet_id           = var.network_database_subnet_id
  network_database_private_dns_zone_id = var.network_database_private_dns_zone_id
  network_frontend_subnet_id           = var.network_frontend_subnet_id
  network_private_subnet_id            = var.network_private_subnet_id
  network_redis_subnet_id              = var.network_redis_subnet_id
  resource_group_name                  = var.resource_group_name
  resource_group_name_dns              = var.resource_group_name_dns

  # Bootstrapping resources
  load_balancer_certificate   = data.azurerm_key_vault_certificate.load_balancer
  tfe_license_secret_id       = module.secrets.tfe_license_secret_id
  vm_certificate_secret       = data.azurerm_key_vault_secret.vm_certificate
  vm_key_secret               = data.azurerm_key_vault_secret.vm_key
  tls_bootstrap_cert_pathname = "/var/lib/terraform-enterprise/certificate.pem"
  tls_bootstrap_key_pathname  = "/var/lib/terraform-enterprise/key.pem"

  # Public Active / Active Scenario
  distribution            = "ubuntu"
  production_type         = "external"
  iact_subnet_list        = var.iact_subnet_list
  vm_node_count           = 2
  vm_sku                  = "Standard_D4_v3"
  vm_image_id             = "ubuntu"
  load_balancer_public    = true
  load_balancer_type      = "application_gateway"
  redis_use_password_auth = false
  redis_use_tls           = false
  tags                    = var.tags
}