module "tfe" {
  source = "../../"

  friendly_name_prefix            = var.friendly_name_prefix
  tfe_license_license_secret_name = var.tfe_license_license_secret_name
  key_vault_name                  = var.key_vault_name
  ca_certificate_name             = var.ca_certificate_name
}
