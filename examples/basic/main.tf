module "tfe_cluster" {
  source  = "hashicorp/terraform-enterprise/azurerm"
  version = "0.1.0"

  license_file                 = "${var.license_path}"
  resource_group_name          = "${var.resource_group}"
  virtual_network_name         = "${var.vnet_name}"
  subnet                       = "${var.subnet_name}"
  key_vault_name               = "${var.key_vault_name}"
  domain                       = "${var.dns_domain}"
  tls_pfx_certificate          = "${var.certificate_path}"
  tls_pfx_certificate_password = "${var.certificate_pass}"
}
