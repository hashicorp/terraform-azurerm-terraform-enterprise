# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

resource "random_string" "friendly_name" {
  length  = 4
  upper   = false
  number  = false
  special = false
}

module "public_active_active" {
  source = "../../"

  domain_name             = var.domain_name
  friendly_name_prefix    = local.friendly_name_prefix
  location                = var.location
  resource_group_name_dns = var.resource_group_name_dns

  # Bootstrapping resources
  load_balancer_certificate   = data.azurerm_key_vault_certificate.load_balancer
  tfe_license_secret_id       = data.azurerm_key_vault_secret.tfe_license.id
  vm_certificate_secret       = data.azurerm_key_vault_secret.vm_certificate
  vm_key_secret               = data.azurerm_key_vault_secret.vm_key
  tls_bootstrap_cert_pathname = "/var/lib/terraform-enterprise/certificate.pem"
  tls_bootstrap_key_pathname  = "/var/lib/terraform-enterprise/key.pem"
  custom_agent_image_tag      = "hashicorp/tfc-agent"
  run_pipeline_mode           = "agent"

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

  tags = local.common_tags
}

