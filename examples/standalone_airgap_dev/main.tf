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
    name = "tfe-license-${random_string.friendly_name.id}"
    path = var.license_file
  }
}

module "standalone_airgap_dev" {
  source = "../../"

  domain_name             = var.domain_name
  friendly_name_prefix    = random_string.friendly_name.id
  location                = var.location
  resource_group_name_dns = var.resource_group_name_dns

  # Bootstrapping resources
  airgap_url                                = var.airgap_url
  tfe_license_bootstrap_airgap_package_path = "/var/lib/ptfe/ptfe.airgap"
  tfe_license_secret_id                     = module.secrets.tfe_license_secret_id
  tls_bootstrap_cert_pathname               = "/var/lib/terraform-enterprise/certificate.pem"
  tls_bootstrap_key_pathname                = "/var/lib/terraform-enterprise/key.pem"
  vm_certificate_secret                     = data.azurerm_key_vault_secret.vm_certificate
  vm_key_secret                             = data.azurerm_key_vault_secret.vm_key

  # Standalone, Mounted Disk Mode, Airgapped Installation Example
  distribution         = "ubuntu"
  installation_type    = "production"
  production_type      = "disk"
  disk_path            = "/opt/hashicorp/data"
  iact_subnet_list     = var.iact_subnet_list
  vm_node_count        = 1
  vm_sku               = "Standard_D4_v3"
  vm_image_id          = "ubuntu"
  load_balancer_public = true
  load_balancer_type   = "load_balancer"

  tags = var.tags
}
