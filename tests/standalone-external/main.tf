# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

resource "random_string" "friendly_name" {
  length  = 4
  upper   = false
  numeric = false
  special = false
}

module "secrets" {
  count        = local.utility_module_test || !var.is_replicated_deployment ? 0 : 1
  source       = "../../fixtures/secrets"
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
  tfe_license_secret_id       = try(module.secrets[0].tfe_license_secret_id, var.tfe_license_secret_id)
  vm_certificate_secret       = data.azurerm_key_vault_secret.vm_certificate
  vm_key_secret               = data.azurerm_key_vault_secret.vm_key
  tls_bootstrap_cert_pathname = "/var/lib/terraform-enterprise/certificate.pem"
  tls_bootstrap_key_pathname  = "/var/lib/terraform-enterprise/key.pem"
  bypass_preflight_checks     = var.bypass_preflight_checks
  custom_agent_image_tag      = "hashicorp/tfc-agent:latest"

  # Standalone External Scenario
  distribution         = "ubuntu"
  database_version     = var.database_version
  iact_subnet_list     = ["0.0.0.0/0"]
  load_balancer_public = true
  load_balancer_type   = "load_balancer"
  operational_mode     = "external"
  vm_node_count        = 1
  vm_sku               = "Standard_D4_v3"
  vm_image_id          = "ubuntu"

  enable_ssh     = true
  create_bastion = false
  tags           = local.common_tags

  # FDO Specific Values
  is_replicated_deployment  = var.is_replicated_deployment
  hc_license                = var.hc_license
  http_port                 = 8080
  https_port                = 8443
  license_reporting_opt_out = true
  registry                  = local.registry
  registry_password         = var.registry_password
  registry_username         = var.registry_username
  tfe_image                 = "${local.registry}/hashicorp/terraform-enterprise:${var.tfe_image_tag}"
}
