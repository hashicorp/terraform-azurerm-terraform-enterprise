# Local variables and conditionals
# --------------------------------
locals {
  # TFE Architecture
  # ----------------
  # Determine whether or not TFE in active-active mode based on node count, by default standalone is assumed
  active_active = var.vm_node_count >= 2 ? true : false
  demo_mode     = var.installation_type == "poc" ? true : false

  # Network
  # -------
  network = try(
    module.network[0],
    {
      bastion_subnet = {
        id = var.network_bastion_subnet_id
      }
      database_private_dns_zone = {
        id = var.network_database_private_dns_zone_id
      }
      database_subnet = {
        id = var.network_database_subnet_id
      }
      frontend_subnet = {
        id = var.network_frontend_subnet_id
      }
      private_subnet = {
        id = var.network_private_subnet_id
      }
      redis_subnet = {
        id = var.network_redis_subnet_id
      }
    }
  )

  # Redis
  # -----
  redis = try(
    module.redis[0],
    {
      host                = null
      pass                = null
      enable_non_ssl_port = null
      use_tls             = null
      use_password_auth   = null
    }
  )

  # User Data
  # ---------
  tls_bootstrap_paths = var.vm_certificate_secret == null ? {
    TlsBootstrapCert = null
    TlsBootstrapKey  = null
    } : {
    TlsBootstrapCert = module.settings.replicated_configuration.TlsBootstrapCert
    TlsBootstrapKey  = module.settings.replicated_configuration.TlsBootstrapKey
  }

  trusted_proxies = concat(
    var.trusted_proxies,
    [var.network_frontend_subnet_cidr]
  )

  database = try(
    module.database[0],
    {
      name    = null
      address = null
      server = {
        administrator_login    = null
        administrator_password = null
      }
    }
  )

  object_storage = try(
    module.object_storage[0],
    {
      storage_account_key            = null
      storage_account_name           = null
      storage_account_container_name = null
    }
  )
}
