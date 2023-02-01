# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "redis_cache" {
  value       = azurerm_redis_cache.tfe_redis
  description = "Redis Instance"
}