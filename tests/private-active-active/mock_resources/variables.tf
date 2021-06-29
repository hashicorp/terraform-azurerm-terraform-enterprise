variable "key_vault_name" {
  type        = string
  description = "Azure Key Vault name containing required certificate"
}

variable "resource_group_name_kv" {
  type        = string
  description = "Name of resource group which contains desired key vault"
}

variable "tags" {
  type        = map(string)
  description = "Map of tags for resource"
}