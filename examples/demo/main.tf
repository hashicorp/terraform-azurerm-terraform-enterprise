# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

resource "random_string" "friendly_name" {
  length  = 4
  upper   = false
  number  = false
  special = false
}

module "secrets" {
  source       = "../../fixtures/secrets"
  count        = local.utility_module_test ? 0 : 1
  key_vault_id = var.key_vault_id

  tfe_license = {
    name = "tfe-license-${local.friendly_name_prefix}"
    path = var.license_file
  }
}

module "standalone_mounted_disk" {
  source = "../../"

  friendly_name_prefix    = local.friendly_name_prefix
  location                = "Central US"
  iact_subnet_list        = ["0.0.0.0/0"]

  # Bootstrapping resources
  tfe_license_secret_id       = try(module.secrets[0].tfe_license_secret_id, var.tfe_license_secret_id)
  tls_bootstrap_cert_pathname = "/var/lib/terraform-enterprise/certificate.pem"
  tls_bootstrap_key_pathname  = "/var/lib/terraform-enterprise/key.pem"
  bypass_preflight_checks     = var.bypass_preflight_checks

  # Standalone Mounted Disk Mode Scenario
  distribution         = var.distribution
  production_type      = "disk"
  disk_path            = "/opt/hashicorp/data"
  vm_node_count        = 1
  load_balancer_type   = "load_balancer"

  enable_ssh     = true
  create_bastion = false
  tags           = local.common_tags
}
