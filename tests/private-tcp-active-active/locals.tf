locals {
  common_tags = {
    Terraform   = "cloud"
    Environment = "${local.friendly_name_prefix}-test-private-tcp-active-active"
    Description = "Private TCP Active/Active"
    Repository  = "hashicorp/terraform-azurerm-terraform-enterprise"
    Team        = "Terraform Enterprise on Prem"
    OkToDelete  = "True"
  }

  friendly_name_prefix = module.mock_resources.friendly_name_prefix
  user_data_ca         = data.azurerm_key_vault_certificate.ca_cert.certificate_data
  user_data_cert       = data.azurerm_key_vault_secret.pem_key.value
  user_data_cert_key   = data.azurerm_key_vault_secret.pem_certificate.value
}

data "azurerm_key_vault" "kv" {
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name_kv
}

data "azurerm_key_vault_certificate" "ca_cert" {
  name         = var.certificate_name
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_key_vault_secret" "pem_key" {
  name         = var.ca_pem_key_secret_name
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_key_vault_secret" "pem_certificate" {
  name         = var.ca_pem_certificate_secret_name
  key_vault_id = data.azurerm_key_vault.kv.id
}
