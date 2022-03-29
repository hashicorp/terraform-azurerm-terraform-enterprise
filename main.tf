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
  count  = local.disk_mode == true || var.installation_type == "poc" ? 0 : 1

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

  active_active = local.active_active
  enable_ssh    = var.enable_ssh

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
  count  = local.disk_mode == true || var.installation_type == "poc" ? 0 : 1

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

# -----------------------------------------------------------------------------
# TFE and Replicated settings to pass to the tfe_init module
# -----------------------------------------------------------------------------
module "settings" {
  source = "git::https://github.com/hashicorp/terraform-random-tfe-utility//modules/settings"

  # TFE Base Configuration
  installation_type = var.installation_type
  production_type   = var.production_type
  disk_path         = var.disk_path
  iact_subnet_list  = var.iact_subnet_list
  trusted_proxies   = local.trusted_proxies
  release_sequence  = var.release_sequence
  pg_extra_params   = var.pg_extra_params

  extra_no_proxy = [
    "127.0.0.1",
    "169.254.169.254",
    ".azure.com",
    ".windows.net",
    ".microsoft.com",
    module.load_balancer.fqdn,
    var.network_cidr
  ]

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
}

# -----------------------------------------------------------------------------
# Azure user data / cloud init used to install and configure TFE on instance(s)
# -----------------------------------------------------------------------------
module "tfe_init" {
  source = "git::https://github.com/hashicorp/terraform-random-tfe-utility//modules/tfe_init"

  # TFE & Replicated Configuration data
  cloud                    = "azurerm"
  distribution             = var.distribution
  tfe_configuration        = module.settings.tfe_configuration
  replicated_configuration = module.settings.replicated_configuration
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
  active_active           = local.active_active
  domain_name             = var.domain_name
  tfe_subdomain           = var.tfe_subdomain
  resource_group_name_dns = module.resource_groups.resource_group_name_dns
  dns_create_record       = var.dns_create_record
  tenant_id               = data.azurerm_client_config.current.tenant_id
  dns_external_fqdn       = var.dns_external_fqdn
  enable_ssh              = var.enable_ssh

  # Secrets
  ca_certificate_secret = var.ca_certificate_secret
  certificate           = var.load_balancer_certificate

  # Network
  network_frontend_subnet_cidr = var.network_frontend_subnet_cidr
  network_frontend_subnet_id   = local.network.frontend_subnet.id

  # Load balancer
  load_balancer_type                         = var.load_balancer_type
  load_balancer_public                       = var.load_balancer_public
  load_balancer_sku_name                     = var.load_balancer_sku_name
  load_balancer_sku_tier                     = var.load_balancer_sku_tier
  load_balancer_waf_firewall_mode            = var.load_balancer_waf_firewall_mode
  load_balancer_waf_rule_set_version         = var.load_balancer_waf_rule_set_version
  load_balancer_waf_file_upload_limit_mb     = var.load_balancer_waf_file_upload_limit_mb
  load_balancer_waf_max_request_body_size_kb = var.load_balancer_waf_max_request_body_size_kb

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
  vm_sku                  = var.vm_sku
  vm_image_id             = var.vm_image_id
  vm_os_disk_disk_size_gb = var.vm_os_disk_disk_size_gb
  vm_subnet_id            = local.network.private_subnet.id
  vm_user                 = var.vm_user
  vm_public_key           = var.vm_public_key == null ? tls_private_key.tfe_ssh[0].public_key_openssh : var.vm_public_key
  vm_userdata_script      = module.tfe_init.tfe_userdata_base64_encoded
  vm_node_count           = var.vm_node_count
  vm_vmss_scale_in_policy = var.vm_vmss_scale_in_policy

  # Load balancer
  load_balancer_type       = var.load_balancer_type
  load_balancer_backend_id = module.load_balancer.load_balancer_backend_id
  load_balancer_public     = var.load_balancer_public

  ca_certificate_secret = var.ca_certificate_secret
  certificate_secret    = var.vm_certificate_secret
  key_secret            = var.vm_key_secret

  tags = var.tags
}
