provider "azurerm" {
  features {}
}

locals {
  replicated_key = "replicated-2.51.3.tar.gz"
  airgap_key     = "v202104-1(528).airgap"
}

# Prerequisite:
# Use bash scripts in files directory to download files replicated and airgap files

module "tfe" {
  source = "../../"

  location             = var.location
  friendly_name_prefix = var.friendly_name_prefix
  tfe_license_filepath = "${path.module}/files/license.rli"

  tfe_airgap_file_paths = {
    replicated_blob = format("../../files/%s", local.replicated_key)
    tfe_blob        = format("../../files/%s", local.airgap_key)
  }

  installation_mode = "airgap"

  resource_group_name     = var.resource_group_name
  resource_group_name_dns = var.resource_group_name_dns

  domain_name   = var.domain_name
  tfe_subdomain = var.tfe_subdomain

  key_vault_name   = var.key_vault_name
  certificate_name = var.certificate_name

  tags = var.tags

  vm_node_count = 2
}
