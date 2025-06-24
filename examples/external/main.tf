provider "azurerm" {

  features {}

  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

resource "random_string" "namespace" {
  length  = 4
  upper   = false
  numeric = false
  special = false
}

# Run TFE external mode
# ----------------------------------------------------------
module "external" {
  source = "../../"

  domain_name              = var.domain_name
  friendly_name_prefix     = random_string.namespace.id
  location                 = var.location
  resource_group_name_dns  = var.resource_group_name_dns
  is_replicated_deployment = false

  # Bootstrapping resources
  load_balancer_certificate   = data.azurerm_key_vault_certificate.load_balancer_certificate
  enable_ssh                  = true
  tls_bootstrap_cert_pathname = "/var/lib/terraform-enterprise/certificate.pem"
  tls_bootstrap_key_pathname  = "/var/lib/terraform-enterprise/key.pem"
  vm_certificate_secret       = data.azurerm_key_vault_secret.certificate
  vm_key_secret               = data.azurerm_key_vault_secret.key

  # Standalone, External Mode, Airgapped Installation Example
  distribution         = "ubuntu"
  iact_subnet_list     = ["0.0.0.0/0"]
  operational_mode     = "external"
  vm_sku               = "Standard_D4s_v6"
  vm_image_id          = "ubuntu"
  load_balancer_public = true
  load_balancer_type   = "application_gateway"
  vm_node_count        = 1

  database_msi_auth_enabled = true


  # FDO Specific Variables
  hc_license                = var.tfe_license
  license_reporting_opt_out = true
  registry                  = var.registry
  registry_password         = var.registry_password
  registry_username         = var.registry_username
  tfe_image                 = var.tfe_image


  #Others
  create_bastion = false
}