# Local variables and conditionals
# --------------------------------
locals {
  # TFE Architecture
  # ----------------
  # Determine whether or not TFE in active-active mode based on node count, by default standalone is assumed
  active_active = var.vm_node_count >= 2 ? true : false

  # DNS
  # ---
  tfe_subdomain     = var.tfe_subdomain == null ? substr(random_pet.tfe_subdomain[0].id, 0, 12) : var.tfe_subdomain
  dns_internal_fqdn = var.domain_name == null ? azurerm_public_ip.tfe_pip.fqdn : "${local.tfe_subdomain}.${var.domain_name}"
  fqdn              = var.dns_external_fqdn == null ? local.dns_internal_fqdn : var.dns_external_fqdn

  # Network
  # -------
  network_name               = var.network_name == null ? module.network[0].network_name : var.network_name
  network_id                 = var.network_id == null ? module.network[0].network_id : var.network_id
  network_private_subnet_id  = var.network_private_subnet_id == null ? module.network[0].network_private_subnet_id : var.network_private_subnet_id
  network_frontend_subnet_id = var.network_frontend_subnet_id == null ? module.network[0].network_frontend_subnet_id : var.network_frontend_subnet_id
  network_bastion_subnet_id  = var.network_bastion_subnet_id == null && var.create_bastion == true ? module.network[0].network_bastion_subnet_id : var.network_bastion_subnet_id
  network_redis_subnet_id    = var.network_redis_subnet_id == null && local.active_active == true ? module.network[0].network_redis_subnet_id : var.network_redis_subnet_id

  # Redis
  # -----
  redis_port = var.redis_enable_non_ssl_port == true ? "6379" : "6380"

  # User Data
  # ---------
  trusted_proxies = concat(
    var.user_data_trusted_proxies,
    [var.network_frontend_subnet_cidr]
  )
}

# Azure resource groups
# ---------------------
module "resource_groups" {
  source = "./modules/resource_groups"

  friendly_name_prefix = var.friendly_name_prefix
  location             = var.location

  resource_group_name     = var.resource_group_name
  resource_group_name_dns = var.resource_group_name_dns

  tags = var.tags
}

# Subdomain
# ---------
resource "random_pet" "tfe_subdomain" {
  count = var.tfe_subdomain == null ? 1 : 0

  length    = 2
  separator = ""
}

# Public IP
# ---------
resource "azurerm_public_ip" "tfe_pip" {
  name                = "${var.friendly_name_prefix}-lb-pip"
  location            = var.location
  resource_group_name = module.resource_groups.resource_group_name

  sku               = "Standard"
  allocation_method = "Static"
  domain_name_label = var.domain_name == null ? local.tfe_subdomain : null

  tags = var.tags
}

# SSH for instances
# -----------------
resource "tls_private_key" "tfe_ssh" {
  count = var.vm_public_key == null ? 1 : 0

  algorithm = "RSA"
  rsa_bits  = 4096
}

# Azure service accounts
# ----------------------
module "service_accounts" {
  source = "./modules/service_accounts"

  friendly_name_prefix = var.friendly_name_prefix
  resource_group_name  = module.resource_groups.resource_group_name
  location             = var.location

  # Application storage
  storage_account_name                           = var.storage_account_name
  storage_account_key                            = var.storage_account_key
  storage_account_primary_blob_connection_string = var.storage_account_primary_blob_connection_string
  storage_account_tier                           = var.storage_account_tier
  storage_account_replication_type               = var.storage_account_replication_type

  tags = var.tags

  depends_on = [
    module.resource_groups
  ]
}

# Azure storage container and storage blob for TFE license file
# -------------------------------------------------------------
module "object_storage" {
  source = "./modules/object_storage"
  count  = var.user_data_installation_type == "poc" ? 0 : 1

  # Application storage
  storage_account_name           = module.service_accounts.storage_account_name
  storage_account_container_name = var.storage_account_container_name

  depends_on = [
    module.resource_groups,
    module.service_accounts
  ]
}

# Azure virtual network, subnet, and security group
# -------------------------------------------------
module "network" {
  source = "./modules/network"
  count  = var.network_id == null ? 1 : 0

  friendly_name_prefix = var.friendly_name_prefix
  resource_group_name  = module.resource_groups.resource_group_name
  location             = var.location

  active_active = local.active_active

  network_cidr                 = var.network_cidr
  network_private_subnet_cidr  = var.network_private_subnet_cidr
  network_frontend_subnet_cidr = var.network_frontend_subnet_cidr
  network_bastion_subnet_cidr  = var.network_bastion_subnet_cidr
  network_redis_subnet_cidr    = var.network_redis_subnet_cidr
  network_allow_range          = var.network_allow_range

  create_bastion = var.create_bastion

  load_balancer_type   = var.load_balancer_type
  load_balancer_public = var.load_balancer_public

  tags = var.tags

  depends_on = [
    module.resource_groups
  ]
}

# Azure cache
# -----------
module "redis" {
  source = "./modules/redis"
  count  = local.active_active == true ? 1 : 0

  resource_group_name = module.resource_groups.resource_group_name
  location            = var.location

  redis_family                        = var.redis_family
  redis_sku_name                      = var.redis_sku_name
  redis_size                          = var.redis_size
  redis_subnet_id                     = local.network_redis_subnet_id
  redis_enable_authentication         = var.redis_enable_authentication
  redis_enable_non_ssl_port           = var.redis_enable_non_ssl_port
  redis_rdb_backup_enabled            = var.redis_rdb_backup_enabled
  redis_rdb_backup_frequency          = var.redis_rdb_backup_frequency
  redis_rdb_backup_max_snapshot_count = var.redis_rdb_backup_max_snapshot_count
  redis_rdb_existing_storage_account  = var.redis_rdb_existing_storage_account != null ? data.azurerm_storage_account.tfe_redis_existing_storage_account[0].primary_blob_connection_string : null

  tags = var.tags

  depends_on = [
    module.resource_groups,
    module.network
  ]
}

# Azure postgres
# --------------
module "database" {
  source = "./modules/database"
  count  = var.user_data_installation_type == "poc" ? 0 : 1

  friendly_name_prefix = var.friendly_name_prefix
  resource_group_name  = module.resource_groups.resource_group_name
  location             = var.location

  database_user         = var.database_user
  database_machine_type = var.database_machine_type
  database_size_mb      = var.database_size_mb
  database_version      = var.database_version
  database_subnet       = local.network_private_subnet_id

  tags = var.tags

  depends_on = [
    module.resource_groups,
    module.network
  ]
}

# Azure user data / cloud init used to install and configure TFE on instance(s)
# -----------------------------------------------------------------------------
module "user_data" {
  source = "./modules/user_data"

  # General
  fqdn          = local.fqdn
  active_active = local.active_active

  # Database
  user_data_pg_dbname   = var.user_data_installation_type == "poc" ? null : module.database[0].database_name
  user_data_pg_netloc   = var.user_data_installation_type == "poc" ? null : "${module.database[0].database_server_fqdn}:5432"
  user_data_pg_user     = var.user_data_installation_type == "poc" ? null : "${module.database[0].database_user}@${module.database[0].database_server_name}"
  user_data_pg_password = var.user_data_installation_type == "poc" ? null : module.database[0].database_password

  # Redis
  user_data_redis_host        = local.active_active == true ? module.redis[0].redis_hostname : null
  user_data_redis_port        = local.active_active == true ? local.redis_port : null
  user_data_redis_pass        = local.active_active == true ? module.redis[0].redis_pass : null
  user_data_redis_use_tls     = local.active_active == true ? var.user_data_redis_use_tls : true
  redis_enable_authentication = local.active_active == true ? var.redis_enable_authentication : true

  # Azure
  user_data_azure_account_key    = var.user_data_installation_type == "poc" ? null : module.service_accounts.storage_account_key
  user_data_azure_account_name   = var.user_data_installation_type == "poc" ? null : module.service_accounts.storage_account_name
  user_data_azure_container_name = var.user_data_installation_type == "poc" ? null : module.object_storage[0].storage_account_container_name

  # TFE
  user_data_release_sequence  = var.user_data_release_sequence
  tfe_license_secret          = var.tfe_license_secret
  user_data_iact_subnet_list  = var.user_data_iact_subnet_list
  user_data_trusted_proxies   = local.trusted_proxies
  user_data_installation_type = var.user_data_installation_type
  user_data_production_type   = var.user_data_installation_type == "poc" ? null : "external"

  # Certificates
  ca_certificate_secret = var.ca_certificate_secret
  certificate_secret    = var.vm_certificate_secret
  key_secret            = var.vm_key_secret

  # Proxy
  proxy_ip   = var.proxy_ip
  proxy_port = var.proxy_port
  no_proxy   = [local.fqdn, var.network_cidr]

  depends_on = [
    module.service_accounts,
    module.object_storage,
    module.network
  ]
}

# Azure bastion service used to connect to TFE instance(s)
# --------------------------------------------------------
module "bastion" {
  source = "./modules/bastion"
  count  = var.create_bastion == true ? 1 : 0

  friendly_name_prefix = var.friendly_name_prefix
  resource_group_name  = module.resource_groups.resource_group_name
  location             = var.location

  bastion_subnet_id = local.network_bastion_subnet_id

  tags = var.tags

  depends_on = [
    module.resource_groups,
    module.network
  ]
}

# Azure load balancer
# -------------------
module "load_balancer" {
  source = "./modules/load_balancer"

  friendly_name_prefix = var.friendly_name_prefix
  resource_group_name  = module.resource_groups.resource_group_name
  location             = var.location
  zones                = var.zones

  # General
  fqdn                    = local.fqdn
  active_active           = local.active_active
  domain_name             = var.domain_name
  tfe_subdomain           = local.tfe_subdomain
  tfe_pip_id              = azurerm_public_ip.tfe_pip.id
  tfe_pip_ip_address      = azurerm_public_ip.tfe_pip.ip_address
  resource_group_name_dns = module.resource_groups.resource_group_name_dns
  dns_create_record       = var.dns_create_record
  tenant_id               = data.azurerm_client_config.current.tenant_id

  # Secrets
  ca_certificate_secret = var.ca_certificate_secret
  certificate           = var.load_balancer_certificate

  # Network
  network_frontend_subnet_cidr = var.network_frontend_subnet_cidr
  network_frontend_subnet_id   = local.network_frontend_subnet_id

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

  depends_on = [
    module.resource_groups,
    module.network
  ]
}

# Azure virtual machine scale set
# -------------------------------
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
  vm_subnet_id            = local.network_private_subnet_id
  vm_user                 = var.vm_user
  vm_public_key           = var.vm_public_key == null ? tls_private_key.tfe_ssh[0].public_key_openssh : var.vm_public_key
  vm_userdata_script      = module.user_data.tfe_userdata_base64_encoded
  vm_node_count           = var.vm_node_count

  # Load balancer
  load_balancer_type       = var.load_balancer_type
  load_balancer_backend_id = module.load_balancer.load_balancer_backend_id
  load_balancer_public     = var.load_balancer_public

  ca_certificate_secret = var.ca_certificate_secret
  certificate_secret    = var.vm_certificate_secret
  key_secret            = var.vm_key_secret

  tags = var.tags

  depends_on = [
    module.resource_groups,
    module.network,
    module.load_balancer,
    module.user_data,
    module.service_accounts
  ]
}
