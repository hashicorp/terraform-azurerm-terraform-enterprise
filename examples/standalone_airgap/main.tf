# Random String for unique names
# ------------------------------
resource "random_string" "friendly_name" {
  length  = 4
  upper   = false
  number  = false
  special = false
}

# Run TFE root module for Standalone Airgapped External Mode
# ----------------------------------------------------------
module "standalone_airgap" {
  source = "../../"

  domain_name             = var.domain_name
  friendly_name_prefix    = random_string.friendly_name.id
  location                = var.location
  resource_group_name_dns = var.resource_group_name_dns

  # Bootstrapping resources
  tfe_license_bootstrap_airgap_package_path = "/var/lib/ptfe/ptfe.airgap"
  tls_bootstrap_cert_pathname               = "/var/lib/terraform-enterprise/certificate.pem"
  tls_bootstrap_key_pathname                = "/var/lib/terraform-enterprise/key.pem"

  # Standalone, Mounted Disk Mode, Airgapped Installation Example
  distribution         = "ubuntu"
  iact_subnet_list     = var.iact_subnet_list
  production_type      = "external"
  load_balancer_public = true
  load_balancer_type   = "load_balancer"
  vm_node_count        = 1
  vm_sku               = "Standard_D4_v3"
  vm_image_id          = var.vm_image_id
  tags                 = var.tags
}