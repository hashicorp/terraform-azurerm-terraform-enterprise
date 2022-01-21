resource "random_string" "friendly_name" {
  length  = 4
  upper   = false
  number  = false
  special = false
}

resource "azurerm_key_vault_secret" "tfe_license" {
  name         = "tfe-license-${local.friendly_name_prefix}"
  value        = filebase64(var.license_file)
  key_vault_id = var.key_vault_id
}

module "standalone_poc" {
  source = "../../"

  domain_name             = "team-private-terraform-enterprise.azure.ptfedev.com"
  friendly_name_prefix    = local.friendly_name_prefix
  location                = "Central US"
  resource_group_name_dns = "ptfedev-com-dns-tls"
  iact_subnet_list        = ["0.0.0.0/0"]

  # Bootstrapping resources
  load_balancer_certificate   = data.azurerm_key_vault_certificate.load_balancer
  tfe_license_secret          = azurerm_key_vault_secret.tfe_license
  vm_certificate_secret       = data.azurerm_key_vault_secret.vm_certificate
  vm_key_secret               = data.azurerm_key_vault_secret.vm_key
  tls_bootstrap_cert_pathname = "/var/lib/terraform-enterprise/certificate.pem"
  tls_bootstrap_key_pathname  = "/var/lib/terraform-enterprise/key.pem"

  # Standalone Demo Mode Scenario
  installation_type    = "poc"
  vm_node_count        = 1
  vm_sku               = "Standard_D4_v3"
  vm_image_id          = "ubuntu"
  load_balancer_public = true
  load_balancer_type   = "application_gateway"

  create_bastion = true
  tags           = local.common_tags
}
