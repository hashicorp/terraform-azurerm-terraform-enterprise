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
