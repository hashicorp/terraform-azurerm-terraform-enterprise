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

  domain_name             = var.domain_name
  friendly_name_prefix    = local.friendly_name_prefix
  location                = "Central US"
  resource_group_name_dns = var.resource_group_name_dns

  # Bootstrapping resources
  load_balancer_certificate   = data.azurerm_key_vault_certificate.load_balancer
  tfe_license_secret_id       = module.secrets.tfe_license_secret_id
  vm_certificate_secret       = data.azurerm_key_vault_secret.vm_certificate
  vm_key_secret               = data.azurerm_key_vault_secret.vm_key
  tls_bootstrap_cert_pathname = "/var/lib/terraform-enterprise/certificate.pem"
  tls_bootstrap_key_pathname  = "/var/lib/terraform-enterprise/key.pem"

  # Standalone External Scenario
  distribution         = "ubuntu"
  production_type      = "external"
  iact_subnet_list     = ["0.0.0.0/0"]
  vm_node_count        = 1
  vm_sku               = "Standard_D4_v3"
  vm_image_id          = "ubuntu"
  load_balancer_public = true
  load_balancer_type   = "load_balancer"
  database_version     = 13

  enable_ssh     = true
  create_bastion = false
  tags           = local.common_tags
}
