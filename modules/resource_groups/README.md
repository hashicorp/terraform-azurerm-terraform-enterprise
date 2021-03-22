# Azure TFE Resource Groups Module

## Required variables

* `friendly_name_prefix` - string value to use as base for resource names
* `location` - string value for Azure location

## Example usage

```hcl
module "resource_groups" {
  source = "./modules/resource_groups"

  friendly_name_prefix = var.friendly_name_prefix
  location             = var.location

  tags = var.tags
}
```

## Resources

* [azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group)
