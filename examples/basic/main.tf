locals {
  license_file = "/path/to/licence/file.rli"
  cert_file    = "/path/to/domain/certificate.pfx"
  domain       = "dns.domain.example.com"
}

variable "cert_pw" {
  type        = "string"
  description = "The Password for the PFX Certificate."
}

provider "azurerm" {
  version = "~>1.32.1"
}

module "tfe_cluster" {
  source = "hashicorp/tfe-ha/azure"
  version = "0.0.1-beta"

  license_file                 = "${local.license_file}"
  primary_count                = 3
  secondary_count              = 5
  distribution                 = "ubuntu"
  resource_group_name          = "existing-rg-name"
  virtual_network_name         = "existing-vnet-name"
  application_subnet_name      = "existing-subnet-within-vnet-name"
  key_vault_name               = "existing-key-vault-in-rg-name"
  domain                       = "${local.domain}"
  domain_resource_group_name   = "existing-rg-where-azure-domain-is-in-name"
  tls_pfx_certificate          = "${local.cert_file}"
  tls_pfx_certificate_password = "${var.cert_pw}"
}

output "tfe_cluster" {
  value = {
    install_id             = "${module.tfe_cluster.install_id}"
    ssh_config_file        = "${module.tfe_cluster.ssh_config_file}"
    ssh_private_key        = "${module.tfe_cluster.ssh_private_key}"
    admin_console_password = "${module.tfe_cluster.admin_console_password}"
    primary_public_ip      = "${module.tfe_cluster.primary_public_ip}"
    console_endpoint       = "${module.tfe_cluster.console_endpoint}"
    application_endpoint   = "${module.tfe_cluster.application_endpoint}"
  }
}