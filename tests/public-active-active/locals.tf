locals {
  common_tags = {
    Terraform   = "cloud"
    Environment = "${local.friendly_name_prefix}-test-public-active-active"
    Description = "Public Active/Active"
    Repository  = "hashicorp/terraform-azurerm-terraform-enterprise"
    Team        = "Terraform Enterprise on Prem"
    OkToDelete  = "True"
  }

  friendly_name_prefix = random_string.friendly_name.id
  key_vault_id         = module.public_active_active.key_vault_id
  // user_data_cert       = base64decode(data.azurerm_key_vault_secret.user_data_cert.value)
  user_data_cert_key   = base64decode(data.azurerm_key_vault_secret.user_data_cert_key.value)
}
