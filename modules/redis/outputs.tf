output "redis_cache" {
  value = azurerm_redis_cache.tfe_redis
  description = "Redis Instance"
}