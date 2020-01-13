module "common" {
  source          = "./modules/common"
  install_id      = random_string.install_id.result
  rg_name         = var.resource_group_name
  vnet = {
    name    = var.virtual_network_name
    rg_name = var.virtual_network_resource_group_name
  }
  subnet_name     = var.subnet
  resource_prefix = var.resource_prefix
  additional_tags = var.additional_tags

  key_type = var.tls_pfx_certificate_key_type
  key_size = var.tls_pfx_certificate_key_size

  domain_rg_name = var.domain_resource_group_name

  key_vault = {
    name    = var.key_vault_name
    rg_name = var.key_vault_resource_group_name
  }

  tls = {
    pfx_cert    = var.tls_pfx_certificate
    pfx_cert_pw = var.tls_pfx_certificate_password
  }
}

module "cluster_lb" {
  source          = "./modules/cluster_lb"
  install_id      = random_string.install_id.result
  rg_name         = module.common.rg_name
  location        = module.common.rg_location
  resource_prefix = var.resource_prefix
  additional_tags = var.additional_tags
  hostname        = var.hostname

  dns = {
    domain  = var.domain
    rg_name = module.common.domain_rg_name
    ttl     = var.dns_ttl
  }

  lb_port = {
    cluster_api = ["6443", "Tcp", "6443"]
    assist      = [local.assistant_port, "Tcp", local.assistant_port]
    app         = ["443", "Tcp", "443"]
    console     = ["8800", "Tcp", "8800"]
  }
}

# We are hardcoding the primary count to 3 for the initial release for stability.
module "configs" {
  source               = "./modules/configs"
  primary_count        = "3"
  license_file         = var.license_file
  cluster_endpoint     = module.cluster_lb.public_ip_address
  cluster_api_endpoint = module.cluster_lb.public_ip_address
  cluster_hostname     = local.cluster_hostname
  distribution         = var.distribution
  encryption_password  = var.encryption_password
  cert_thumbprint      = module.common.cert_thumbprint
  assistant_port       = local.assistant_port
  http_proxy_url       = var.http_proxy_url
  installer_url        = var.installer_url
  import_key           = var.import_key
  ca_bundle_url        = var.ca_bundle_url
  weave_cidr           = var.weave_cidr
  repl_cidr            = var.repl_cidr
  release_sequence     = var.release_sequence
  additional_tags      = var.additional_tags

  iact = {
    subnet_list       = var.iact_subnet_list
    subnet_time_limit = var.iact_subnet_time_limit
  }

  postgresql = {
    user         = var.postgresql_user
    password     = var.postgresql_password
    address      = var.postgresql_address
    database     = var.postgresql_database
    extra_params = var.postgresql_extra_params
  }

  azure_es = {
    enable       = var.postgresql_database == "" ? true : false
    account_name = var.azure_es_account_name
    account_key  = var.azure_es_account_key
    container    = var.azure_es_container
  }

  airgap = {
    enable        = var.airgap_mode_enable
    package_url   = var.airgap_package_url
    installer_url = var.airgap_installer_url
  }
}

module "primaries" {
  source            = "./modules/primaries"
  install_id        = random_string.install_id.result
  rg_name           = module.common.rg_name
  location          = module.common.rg_location
  subnet_id         = module.common.app_subnet_id
  resource_prefix   = var.resource_prefix
  external_services = var.postgresql_database == "" ? "False" : "True"
  additional_tags   = var.additional_tags

  username                = var.ssh_user
  os_disk_size            = var.os_disk_size
  cluster_backend_pool_id = module.cluster_lb.backend_pool_id
  storage_image           = var.storage_image
  cloud_init_data_list    = module.configs.primary_cloud_init_list

  key_vault = {
    id       = module.common.vault_id
    cert_uri = module.common.cert_secret_id
  }

  ssh = {
    public_key       = module.common.ssh_public_key
    private_key_path = module.common.ssh_private_key_path
  }

  # We are hardcoding the primary count to 3 for the initial release for stability.
  vm = {
    count = 3
    size  = var.primary_vm_size
  }
}

module "secondaries" {
  source          = "./modules/secondaries"
  install_id      = random_string.install_id.result
  rg_name         = module.common.rg_name
  location        = module.common.rg_location
  subnet_id       = module.common.app_subnet_id
  storage_image   = var.storage_image
  ssh_public_key  = module.common.ssh_public_key
  cloud_init_data = module.configs.secondary_cloud_init
  username        = var.ssh_user
  resource_prefix = var.resource_prefix
  additional_tags = var.additional_tags

  vm = {
    size      = local.rendered_secondary_vm_size
    count     = var.secondary_count
    size_tier = var.vm_size_tier
  }
}

