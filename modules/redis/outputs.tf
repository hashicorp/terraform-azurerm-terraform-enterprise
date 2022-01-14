output "host" {
  value       = azurerm_redis_cache.tfe_redis.hostname
  description = "The Hostname of the Redis Instance"
}

output "ssl_port" {
  value       = azurerm_redis_cache.tfe_redis.ssl_port
  description = "The SSL Port of the Redis Instance"
}

output "pass" {
  value       = azurerm_redis_cache.tfe_redis.primary_access_key
  description = "The Primary Access Key for the Redis Instance"
}

output "enable_non_ssl_port" {
  value       = var.redis.enable_non_ssl_port
  description = "If true, the external Redis instance will use port 6379, otherwise 6380"
}

output "use_password_auth" {
  value       = var.redis.use_password_auth
  description = "Redis service requires a password."
}

output "use_tls" {
  value       = var.redis.use_tls
  description = "Redis service requires a password."
}