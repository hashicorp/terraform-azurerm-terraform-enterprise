# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# Random String for unique names
# ------------------------------
resource "random_string" "friendly_name" {
  length  = 4
  upper   = false
  numeric = false
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

# Standalone Airgapped - DEV (bootstrap prerequisites)
# ----------------------------------------------------
module "standalone_airgap_dev" {
  source = "../../"

  domain_name             = var.domain_name
  friendly_name_prefix    = random_string.friendly_name.id
  location                = var.location
  resource_group_name_dns = var.resource_group_name_dns

  # Bootstrapping resources
  airgap_url                                = var.airgap_url
  load_balancer_certificate                 = data.azurerm_key_vault_certificate.load_balancer
  tls_bootstrap_cert_pathname               = "/var/lib/terraform-enterprise/certificate.pem"
  tls_bootstrap_key_pathname                = "/var/lib/terraform-enterprise/key.pem"
  tfe_license_secret_id                     = module.secrets.tfe_license_secret_id
  tfe_license_bootstrap_airgap_package_path = "/var/lib/ptfe/ptfe.airgap"
  vm_certificate_secret                     = data.azurerm_key_vault_secret.vm_certificate
  vm_key_secret                             = data.azurerm_key_vault_secret.vm_key

  # Standalone External Scenario
  distribution         = "ubuntu"
  operational_mode     = "external"
  iact_subnet_list     = var.iact_subnet_list
  vm_node_count        = 1
  vm_sku               = "Standard_D4_v3"
  vm_image_id          = "ubuntu"
  load_balancer_public = true
  load_balancer_type   = "load_balancer"

  create_bastion = true
  tags           = var.tags
}
