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

  domain_name             = var.domain_name
  friendly_name_prefix    = local.friendly_name_prefix
  location                = "Central US"
  resource_group_name_dns = var.resource_group_name_dns
  iact_subnet_list        = ["0.0.0.0/0"]

  # Bootstrapping resources
  load_balancer_certificate   = data.azurerm_key_vault_certificate.load_balancer
  tfe_license_secret_id       = try(module.secrets[0].tfe_license_secret_id, var.tfe_license_secret_id)
  vm_certificate_secret       = data.azurerm_key_vault_secret.vm_certificate
  vm_key_secret               = data.azurerm_key_vault_secret.vm_key
  tls_bootstrap_cert_pathname = "/var/lib/terraform-enterprise/certificate.pem"
  tls_bootstrap_key_pathname  = "/var/lib/terraform-enterprise/key.pem"
  bypass_preflight_checks     = var.bypass_preflight_checks

  # Standalone Mounted Disk Mode Scenario
  distribution         = var.distribution
  production_type      = "disk"
  disk_path            = "/opt/hashicorp/data"
  vm_node_count        = 1
  vm_sku               = "Standard_D4_v3"
  vm_image_id          = local.vm_image_id
  vm_image_publisher   = local.vm_image_publisher
  vm_image_offer       = local.vm_image_offer
  vm_image_sku         = local.vm_image_sku
  vm_image_version     = local.vm_image_version
  load_balancer_public = true
  load_balancer_type   = "load_balancer"

  # VM Data Disk
  vm_data_disk_caching              = "ReadWrite"
  vm_data_disk_create_option        = "Empty"
  vm_data_disk_storage_account_type = "StandardSSD_LRS"
  vm_data_disk_lun                  = 0
  vm_data_disk_disk_size_gb         = 100

  enable_ssh     = true
  create_bastion = false
  tags           = local.common_tags
}
