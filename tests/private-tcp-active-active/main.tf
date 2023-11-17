# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

resource "random_string" "friendly_name" {
  length  = 4
  upper   = false
  numeric = false
  special = false
}

module "bastion_vm" {
  source               = "../../fixtures/bastion_vm"
  friendly_name_prefix = local.friendly_name_prefix

  location             = var.location
  resource_group_name  = local.resource_group_name
  virtual_network_name = module.private_tcp_active_active.network.network.name
  network_allow_range  = var.network_allow_range
  bastion_subnet_cidr  = "10.0.16.0/20"
  ssh_public_key       = data.azurerm_key_vault_secret.bastion_public_ssh_key.value
  bastion_user         = "bastionuser"

  tags = local.common_tags
}

module "test_proxy" {
  source               = "../../fixtures/test_proxy"
  friendly_name_prefix = local.friendly_name_prefix

  location                         = var.location
  resource_group_name              = local.resource_group_name
  virtual_network_name             = module.private_tcp_active_active.network.network.name
  proxy_subnet_cidr                = local.network_proxy_subnet_cidr
  proxy_user                       = local.proxy_user
  proxy_public_ssh_key_secret_name = data.azurerm_key_vault_secret.proxy_public_ssh_key.value
  key_vault_id                     = var.key_vault_id
  mitmproxy_ca_certificate_secret  = data.azurerm_key_vault_secret.ca_certificate.id
  mitmproxy_ca_private_key_secret  = data.azurerm_key_vault_secret.ca_key.id

  tags = local.common_tags

}

module "private_tcp_active_active" {
  source = "../../"

  location             = var.location
  friendly_name_prefix = local.friendly_name_prefix

  resource_group_name_dns = var.resource_group_name_dns
  domain_name             = var.domain_name
  iact_subnet_list        = ["${module.bastion_vm.private_ip}/32"]

  # Bootstrapping resources
  bypass_preflight_checks     = true
  tfe_license_secret_id       = var.tfe_license_secret_name == null ? var.tfe_license_secret_name : data.azurerm_key_vault_secret.tfe_license[0].id
  vm_certificate_secret       = data.azurerm_key_vault_secret.vm_certificate
  vm_key_secret               = data.azurerm_key_vault_secret.vm_key
  tls_bootstrap_cert_pathname = "/var/lib/terraform-enterprise/certificate.pem"
  tls_bootstrap_key_pathname  = "/var/lib/terraform-enterprise/key.pem"

  # Behind proxy information
  ca_certificate_secret = data.azurerm_key_vault_secret.ca_certificate
  proxy_ip              = module.test_proxy.private_ip
  proxy_port            = local.proxy_port

  # Private Active / Active Scenario
  consolidated_services_enabled = var.consolidated_services_enabled
  distribution                  = "rhel"
  load_balancer_public          = false
  load_balancer_type            = "load_balancer"
  redis_use_password_auth       = true
  redis_use_tls                 = true
  redis_rdb_backup_enabled      = true
  redis_rdb_backup_frequency    = 60
  production_type               = "external"
  vm_node_count                 = 2
  vm_sku                        = "Standard_D32a_v4"
  vm_image_id                   = "rhel"

  create_bastion = false
  tags           = local.common_tags

  # FDO Specific Values
  is_replicated_deployment  = var.is_replicated_deployment
  hc_license                = var.hc_license
  http_port                 = 8080
  https_port                = 8443
  license_reporting_opt_out = true
  registry                  = local.registry
  registry_password         = var.registry_password
  registry_username         = var.registry_username
  tfe_image                 = "${local.registry}/hashicorp/terraform-enterprise:${var.tfe_image_tag}"
}
