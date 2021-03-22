# Azure TFE Redis Module

## Required variables

* `friendly_name_prefix` - string value to use as base for resource names
* `resource_group_name` - string value for Azure resource group name
* `location` - string value for Azure location
* `redis_subnet_id` - string value for the Azure virtual network subnet ID

## Example usage

```hcl
module "redis" {
  source = "./modules/redis"

  friendly_name_prefix = var.friendly_name_prefix
  resource_group_name  = local.resource_group_name
  location             = var.location

  redis_size      = var.redis_size
  redis_subnet_id = local.network_private_subnet_id
}
```

## Resources

* [random_pet](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet)
* [azurerm_redis_cache](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/redis_cache)
