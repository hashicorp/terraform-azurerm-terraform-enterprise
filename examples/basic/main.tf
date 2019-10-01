variable "cert_file" {}

variable "domain" {}

variable "license_file_path" {}

variable "cert_pw" {
  type        = "string"
  description = "The Password for the PFX Certificate."
}

provider "azurerm" {
  version = "~>1.32.1"
}

module "tfe_cluster" {
  source  = "hashicorp/terraform-enterproze/azurerm"
  version = "0.0.3-beta"

  license_file                 = "${var.license_file}"
  resource_group_name          = "existing-rg-name"
  virtual_network_name         = "existing-vnet-name"
  subnet                       = "existing-subnet-within-vnet-name"
  key_vault_name               = "existing-key-vault-in-rg-name"
  domain                       = "${var.domain}"
  tls_pfx_certificate          = "${var.cert_file}"
  tls_pfx_certificate_password = "${var.cert_pw}"
}

output "tfe_cluster" {
  value = {
    application_endpoint         = "${module.tfe_cluster.application_endpoint}"
    application_health_check     = "${module.tfe_cluster.health_check_endpoint}"
    install_id                   = "${module.tfe_cluster.install_id}"
    installer_dashboard_endpoint = "${module.tfe_cluster.console_endpoint}"
    installer_dashboard_password = "${module.tfe_cluster.admin_console_password}"
    primary_public_ip            = "${module.tfe_cluster.primary_public_ip}"
    ssh_config_file              = "${module.tfe_cluster.ssh_config_file}"
    ssh_private_key              = "${module.tfe_cluster.ssh_private_key}"
  }
}
