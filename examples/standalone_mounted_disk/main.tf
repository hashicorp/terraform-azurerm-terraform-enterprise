# Random String for unique names
# ------------------------------
resource "random_string" "friendly_name" {
  length  = 4
  upper   = false
  number  = false
  special = false
}

# Store TFE License as secret
# ---------------------------
module "secrets" {
  source = "../../fixtures/secrets"

  key_vault_id = var.key_vault_id
  tfe_license = {
    name = "tfe-license-${random_string.friendly_name.id}"
    path = var.license_file
  }
}

# Standalone, mounted disk
# ------------------------
module "standalone_mounted_disk" {
  source = "../../"

  domain_name             = var.domain_name
  friendly_name_prefix    = random_string.friendly_name.id
  location                = var.location
  resource_group_name_dns = var.resource_group_name_dns

  # Bootstrapping resources
  load_balancer_certificate   = data.azurerm_key_vault_certificate.load_balancer
  tfe_license_secret_id       = module.secrets.tfe_license_secret_id
  tls_bootstrap_cert_pathname = "/var/lib/terraform-enterprise/certificate.pem"
  tls_bootstrap_key_pathname  = "/var/lib/terraform-enterprise/key.pem"
  vm_certificate_secret       = data.azurerm_key_vault_secret.vm_certificate
  vm_key_secret               = data.azurerm_key_vault_secret.vm_key

  # Standalone Mounted Disk Mode Example
  disk_path            = "/opt/hashicorp/data"
  distribution         = "ubuntu"
  iact_subnet_list     = var.iact_subnet_list
  load_balancer_public = true
  load_balancer_type   = "application_gateway"
  production_type      = "disk"
  vm_node_count        = 1
  vm_sku               = "Standard_D4_v3"
  vm_image_id          = "ubuntu"

  # VM Data Disk
  vm_data_disk_caching              = "ReadWrite"
  vm_data_disk_create_option        = "Empty"
  vm_data_disk_storage_account_type = "StandardSSD_LRS"
  vm_data_disk_lun                  = 0
  vm_data_disk_disk_size_gb         = 100

  create_bastion = true
  tags           = var.tags
}
