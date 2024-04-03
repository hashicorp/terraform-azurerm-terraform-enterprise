# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# -----------------------------------------------------------------------------
# Azure resource groups
# -----------------------------------------------------------------------------
module "resource_groups" {
  source = "./modules/resource_groups"

  friendly_name_prefix = var.friendly_name_prefix
  location             = var.location

  resource_group_name     = var.resource_group_name
  resource_group_name_dns = var.resource_group_name_dns

  tags = var.tags
}

# -----------------------------------------------------------------------------
# SSH for instances
# -----------------------------------------------------------------------------
resource "tls_private_key" "tfe_ssh" {
  count = var.vm_public_key == null ? 1 : 0

  algorithm = "RSA"
  rsa_bits  = 4096
}

# -----------------------------------------------------------------------------
# Azure storage container and storage blob for TFE license file
# -----------------------------------------------------------------------------
module "object_storage" {
  source = "./modules/object_storage"
  count  = local.disk_mode == true ? 0 : 1

  friendly_name_prefix = var.friendly_name_prefix
  resource_group_name  = module.resource_groups.resource_group_name
  location             = var.location

  # Application storage
  storage_account_name                           = var.storage_account_name
  storage_account_container_name                 = var.storage_account_container_name
  storage_account_key                            = var.storage_account_key
  storage_account_primary_blob_connection_string = var.storage_account_primary_blob_connection_string
  storage_account_tier                           = var.storage_account_tier
  storage_account_replication_type               = var.storage_account_replication_type

  tags = var.tags
}

# -----------------------------------------------------------------------------
# Azure virtual network, subnet, and security group
# -----------------------------------------------------------------------------
module "network" {
  source = "./modules/network"
  count  = var.network_private_subnet_id == null ? 1 : 0

  friendly_name_prefix = var.friendly_name_prefix
  resource_group_name  = module.resource_groups.resource_group_name
  location             = var.location

  active_active            = local.active_active
  enable_ssh               = var.enable_ssh
  is_replicated_deployment = var.is_replicated_deployment

  network_allow_range          = var.network_allow_range
  network_bastion_subnet_cidr  = var.network_bastion_subnet_cidr
  network_cidr                 = var.network_cidr
  network_database_subnet_cidr = var.network_database_subnet_cidr
  network_frontend_subnet_cidr = var.network_frontend_subnet_cidr
  network_private_subnet_cidr  = var.network_private_subnet_cidr
  network_redis_subnet_cidr    = var.network_redis_subnet_cidr

  create_bastion = var.create_bastion
  disk_mode      = local.disk_mode

  load_balancer_type   = var.load_balancer_type
  load_balancer_public = var.load_balancer_public

  tags = var.tags
}

# -----------------------------------------------------------------------------
# Azure cache
# -----------------------------------------------------------------------------
module "redis" {
  source = "./modules/redis"
  count  = local.active_active == true ? 1 : 0

  resource_group_name = module.resource_groups.resource_group_name
  location            = var.location
  redis_subnet_id     = local.network.redis_subnet.id

  redis = {
    family                        = var.redis_family
    sku_name                      = var.redis_sku_name
    size                          = var.redis_size
    use_password_auth             = var.redis_use_password_auth
    rdb_backup_enabled            = var.redis_rdb_backup_enabled
    rdb_backup_frequency          = var.redis_rdb_backup_frequency
    rdb_backup_max_snapshot_count = var.redis_rdb_backup_max_snapshot_count
    rdb_existing_storage_account  = var.redis_rdb_existing_storage_account != null ? data.azurerm_storage_account.tfe_redis_existing_storage_account[0].primary_blob_connection_string : null
    minimum_tls_version           = var.redis_minimum_tls_version
    use_tls                       = var.redis_use_tls
  }


  tags = var.tags
}

# -----------------------------------------------------------------------------
# Azure postgres
# -----------------------------------------------------------------------------
module "database" {
  source = "./modules/database"
  count  = local.disk_mode == true ? 0 : 1

  friendly_name_prefix = var.friendly_name_prefix
  resource_group_name  = module.resource_groups.resource_group_name
  location             = var.location

  database_machine_type          = var.database_machine_type
  database_private_dns_zone_id   = local.network.database_private_dns_zone.id
  database_size_mb               = var.database_size_mb
  database_subnet_id             = local.network.database_subnet.id
  database_user                  = var.database_user
  database_extensions            = var.database_extensions
  database_version               = var.database_version
  database_backup_retention_days = var.database_backup_retention_days
  database_availability_zone     = var.database_availability_zone


  tags = var.tags
}

# ---------------------------------------------------------------------------------------------------------------
# Azure user data / cloud init used to install and configure TFE on instance(s) using Flexible Deployment Options
# ---------------------------------------------------------------------------------------------------------------
module "tfe_init_fdo" {
  source = "git::https://github.com/hashicorp/terraform-random-tfe-utility//modules/tfe_init?ref=main"
  count  = var.is_replicated_deployment ? 0 : 1

  cloud             = "azurerm"
  distribution      = var.distribution
  disk_path         = var.disk_path
  disk_device_name  = var.production_type == "disk" ? "disk/azure/scsi1/lun${var.vm_data_disk_lun}" : null
  operational_mode  = local.active_active ? "active-active" : var.production_type
  custom_image_tag  = var.custom_image_tag
  enable_monitoring = var.enable_monitoring

  ca_certificate_secret_id = var.ca_certificate_secret == null ? null : var.ca_certificate_secret.id
  certificate_secret_id    = var.vm_certificate_secret == null ? null : var.vm_certificate_secret.id
  key_secret_id            = var.vm_key_secret == null ? null : var.vm_key_secret.id

  proxy_ip   = var.proxy_ip
  proxy_port = var.proxy_port
  extra_no_proxy = [
    "127.0.0.1",
    "169.254.169.254",
    ".azure.com",
    ".windows.net",
    ".microsoft.com",
    module.load_balancer.fqdn,
    var.network_cidr
  ]

  registry          = var.registry
  registry_password = var.registry == "images.releases.hashicorp.com" ? var.hc_license : var.registry_password
  registry_username = var.registry_username

  container_runtime_engine = var.container_runtime_engine
  tfe_image                = var.tfe_image
  podman_kube_yaml         = module.runtime_container_engine_config[0].podman_kube_yaml
  docker_compose_yaml      = module.runtime_container_engine_config[0].docker_compose_yaml
}

# ------------------------------------------------------------------------------------
# Docker Compose File Config for TFE on instance(s) using Flexible Deployment Options
# ------------------------------------------------------------------------------------
module "runtime_container_engine_config" {
  source = "git::https://github.com/hashicorp/terraform-random-tfe-utility//modules/runtime_container_engine_config?ref=main"
  count  = var.is_replicated_deployment ? 0 : 1

  license_reporting_opt_out   = var.license_reporting_opt_out
  hostname                    = module.load_balancer.fqdn
  capacity_concurrency        = var.capacity_concurrency
  capacity_cpu                = var.capacity_cpu
  capacity_memory             = var.capacity_memory
  disk_path                   = local.disk_mode ? var.disk_path : null
  iact_subnets                = join(",", var.iact_subnet_list)
  iact_time_limit             = var.iact_subnet_time_limit
  operational_mode            = local.active_active ? "active-active" : var.production_type
  run_pipeline_image          = var.run_pipeline_image
  tfe_image                   = var.tfe_image
  tfe_license                 = var.hc_license
  tls_ciphers                 = var.tls_ciphers
  tls_version                 = var.tls_version
  metrics_endpoint_enabled    = var.metrics_endpoint_enabled
  metrics_endpoint_port_http  = var.metrics_endpoint_port_http
  metrics_endpoint_port_https = var.metrics_endpoint_port_https

  cert_file          = "/etc/ssl/private/terraform-enterprise/cert.pem"
  key_file           = "/etc/ssl/private/terraform-enterprise/key.pem"
  tls_ca_bundle_file = var.ca_certificate_secret != null ? "/etc/ssl/private/terraform-enterprise/bundle.pem" : null

  database_user       = local.database.server.administrator_login
  database_password   = local.database.server.administrator_password
  database_host       = local.database.address
  database_name       = local.database.name
  database_parameters = "sslmode=require"

  storage_type = "azure"

  azure_account_key  = local.object_storage.storage_account_key
  azure_account_name = local.object_storage.storage_account_name
  azure_container    = local.object_storage.storage_account_container_name

  http_port       = var.http_port
  https_port      = var.https_port
  http_proxy      = var.proxy_ip != null ? "${var.proxy_ip}:${var.proxy_port}" : null
  https_proxy     = var.proxy_ip != null ? "${var.proxy_ip}:${var.proxy_port}" : null
  no_proxy        = local.no_proxy
  trusted_proxies = local.trusted_proxies

  redis_host     = local.redis.hostname
  redis_user     = ""
  redis_password = local.redis.primary_access_key
  redis_use_tls  = local.redis.hostname == null ? null : var.redis_use_tls
  redis_use_auth = local.redis.hostname == null ? null : var.redis_use_password_auth

  vault_address   = var.extern_vault_addr
  vault_namespace = var.extern_vault_namespace
  vault_path      = var.extern_vault_path
  vault_role_id   = var.extern_vault_role_id
  vault_secret_id = var.extern_vault_secret_id
}

# ------------------------------------------------------------------------------------------------
# TFE and Replicated settings to pass to the tfe_init_replicated module for Replicated deployment
# ------------------------------------------------------------------------------------------------
module "settings" {
  source = "git::https://github.com/hashicorp/terraform-random-tfe-utility//modules/settings?ref=main"
  count  = var.is_replicated_deployment ? 1 : 0

  # TFE Base Configuration
  custom_image_tag       = var.custom_image_tag
  custom_agent_image_tag = var.custom_agent_image_tag
  disk_path              = var.disk_path
  hairpin_addressing     = var.hairpin_addressing
  iact_subnet_list       = var.iact_subnet_list
  pg_extra_params        = var.pg_extra_params
  production_type        = var.production_type
  release_sequence       = var.release_sequence
  trusted_proxies        = local.trusted_proxies

  extra_no_proxy = local.no_proxy

  # Replicated Base Configuration
  hostname                                  = module.load_balancer.fqdn
  enable_active_active                      = local.active_active
  tfe_license_bootstrap_airgap_package_path = var.tfe_license_bootstrap_airgap_package_path
  tfe_license_file_location                 = var.tfe_license_file_location
  tls_bootstrap_cert_pathname               = var.tls_bootstrap_cert_pathname
  tls_bootstrap_key_pathname                = var.tls_bootstrap_key_pathname
  bypass_preflight_checks                   = var.bypass_preflight_checks

  # Database
  pg_dbname   = local.database.name
  pg_netloc   = local.database.address
  pg_user     = local.database.server.administrator_login
  pg_password = local.database.server.administrator_password

  # Redis
  redis_host              = local.redis.hostname
  redis_pass              = local.redis.primary_access_key
  redis_use_tls           = local.redis.hostname == null ? null : var.redis_use_tls
  redis_use_password_auth = local.redis.hostname == null ? null : var.redis_use_password_auth

  # Azure
  azure_account_key  = local.object_storage.storage_account_key
  azure_account_name = local.object_storage.storage_account_name
  azure_container    = local.object_storage.storage_account_container_name

  # Metrics
  metrics_endpoint_enabled    = var.metrics_endpoint_enabled
  metrics_endpoint_port_http  = var.metrics_endpoint_port_http
  metrics_endpoint_port_https = var.metrics_endpoint_port_https
}

# -----------------------------------------------------------------------------
# Azure user data / cloud init used to install and configure TFE on instance(s)
# -----------------------------------------------------------------------------
module "tfe_init_replicated" {
  source = "git::https://github.com/hashicorp/terraform-random-tfe-utility//modules/tfe_init_replicated?ref=main"
  count  = var.is_replicated_deployment ? 1 : 0

  # TFE & Replicated Configuration data
  cloud                    = "azurerm"
  distribution             = var.distribution
  disk_path                = var.disk_path
  disk_device_name         = var.production_type == "disk" ? "disk/azure/scsi1/lun${var.vm_data_disk_lun}" : null
  tfe_configuration        = module.settings[0].tfe_configuration
  replicated_configuration = module.settings[0].replicated_configuration
  airgap_url               = var.airgap_url

  # Secrets
  ca_certificate_secret_id = var.ca_certificate_secret == null ? null : var.ca_certificate_secret.id
  certificate_secret_id    = var.vm_certificate_secret == null ? null : var.vm_certificate_secret.id
  key_secret_id            = var.vm_key_secret == null ? null : var.vm_key_secret.id
  tfe_license_secret_id    = var.tfe_license_secret_id

  # Proxy information
  proxy_ip   = var.proxy_ip
  proxy_port = var.proxy_port
}

# -----------------------------------------------------------------------------
# Azure bastion service used to connect to TFE instance(s)
# -----------------------------------------------------------------------------
module "bastion" {
  source = "./modules/bastion"
  count  = var.create_bastion == true ? 1 : 0

  friendly_name_prefix = var.friendly_name_prefix
  resource_group_name  = module.resource_groups.resource_group_name
  location             = var.location

  bastion_subnet_id = local.network.bastion_subnet.id

  tags = var.tags
}

# -----------------------------------------------------------------------------
# Azure load balancer
# -----------------------------------------------------------------------------
module "load_balancer" {
  source = "./modules/load_balancer"

  friendly_name_prefix = var.friendly_name_prefix
  resource_group_name  = module.resource_groups.resource_group_name
  location             = var.location
  zones                = var.zones

  # General
  active_active            = local.active_active
  domain_name              = var.domain_name
  is_replicated_deployment = var.is_replicated_deployment
  tfe_subdomain            = var.tfe_subdomain
  resource_group_name_dns  = module.resource_groups.resource_group_name_dns
  dns_create_record        = var.dns_create_record
  tenant_id                = data.azurerm_client_config.current.tenant_id
  dns_external_fqdn        = var.dns_external_fqdn
  enable_ssh               = var.enable_ssh

  # Secrets
  ca_certificate_secret = var.ca_certificate_secret
  certificate           = var.load_balancer_certificate

  # Network
  network_frontend_subnet_cidr = var.network_frontend_subnet_cidr
  network_frontend_subnet_id   = local.network.frontend_subnet.id
  network_private_ip           = var.network_private_ip

  # Load balancer
  load_balancer_type                                  = var.load_balancer_type
  load_balancer_enable_http2                          = var.load_balancer_enable_http2
  load_balancer_public                                = var.load_balancer_public
  load_balancer_request_routing_rule_minimum_priority = var.load_balancer_request_routing_rule_minimum_priority
  load_balancer_sku_capacity                          = var.load_balancer_sku_capacity
  load_balancer_sku_name                              = var.load_balancer_sku_name
  load_balancer_sku_tier                              = var.load_balancer_sku_tier
  load_balancer_waf_firewall_mode                     = var.load_balancer_waf_firewall_mode
  load_balancer_waf_rule_set_version                  = var.load_balancer_waf_rule_set_version
  load_balancer_waf_file_upload_limit_mb              = var.load_balancer_waf_file_upload_limit_mb
  load_balancer_waf_max_request_body_size_kb          = var.load_balancer_waf_max_request_body_size_kb

  tags = var.tags
}

# -----------------------------------------------------------------------------
# Azure virtual machine scale set
# -----------------------------------------------------------------------------
module "vm" {
  source = "./modules/vm"

  friendly_name_prefix = var.friendly_name_prefix
  resource_group_name  = module.resource_groups.resource_group_name
  location             = var.location
  tenant_id            = data.azurerm_client_config.current.tenant_id

  # VM
  disk_mode                               = local.disk_mode
  vm_data_disk_caching                    = var.vm_data_disk_caching
  vm_data_disk_create_option              = var.vm_data_disk_create_option
  vm_data_disk_disk_size_gb               = var.vm_data_disk_disk_size_gb
  vm_data_disk_lun                        = var.vm_data_disk_lun
  vm_data_disk_storage_account_type       = var.vm_data_disk_storage_account_type
  vm_identity_type                        = var.vm_identity_type
  vm_image_id                             = var.vm_image_id
  vm_image_publisher                      = var.vm_image_publisher
  vm_image_offer                          = var.vm_image_offer
  vm_image_sku                            = var.vm_image_sku
  vm_image_version                        = var.vm_image_version
  vm_node_count                           = var.vm_node_count
  vm_os_disk_caching                      = var.vm_os_disk_caching
  vm_os_disk_disk_size_gb                 = var.vm_os_disk_disk_size_gb
  vm_os_disk_storage_account_type         = var.vm_os_disk_storage_account_type
  vm_overprovision                        = var.vm_overprovision
  vm_public_key                           = var.vm_public_key == null ? tls_private_key.tfe_ssh[0].public_key_openssh : var.vm_public_key
  vm_sku                                  = var.vm_sku
  vm_subnet_id                            = local.network.private_subnet.id
  vm_upgrade_mode                         = var.vm_upgrade_mode
  vm_user                                 = var.vm_user
  vm_userdata_script                      = var.is_replicated_deployment ? module.tfe_init_replicated[0].tfe_userdata_base64_encoded : module.tfe_init_fdo[0].tfe_userdata_base64_encoded
  vm_vmss_scale_in_rule                   = var.vm_vmss_scale_in_rule
  vm_vmss_scale_in_force_deletion_enabled = var.vm_vmss_scale_in_force_deletion_enabled
  vm_zone_balance                         = var.vm_zone_balance
  zones                                   = var.zones

  # Load balancer
  load_balancer_type       = var.load_balancer_type
  load_balancer_backend_id = module.load_balancer.load_balancer_backend_id
  load_balancer_public     = var.load_balancer_public

  ca_certificate_secret = var.ca_certificate_secret
  certificate_secret    = var.vm_certificate_secret
  key_secret            = var.vm_key_secret

  tags = var.tags
}
