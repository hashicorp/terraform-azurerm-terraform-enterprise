# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# Local variables and conditionals
# --------------------------------
locals {
  # TFE Architecture
  # ----------------
  # Determine whether or not TFE in active-active mode based on node count, by default standalone is assumed
  disk_mode     = var.production_type == "disk" ? true : false

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
    module.redis[0].redis_cache,
    {
      hostname           = null
      primary_access_key = null
    }
  )

  # User Data
  # ---------
  no_proxy = concat([
    "127.0.0.1",
    "localhost",
    "169.254.169.254",
    ".azure.com",
    ".windows.net",
    ".microsoft.com",
    module.load_balancer.fqdn,
    var.network_cidr,
  ], var.no_proxy)

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
