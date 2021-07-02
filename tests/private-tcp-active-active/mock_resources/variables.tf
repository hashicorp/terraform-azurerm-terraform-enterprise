variable "tags" {
  default     = {}
  type        = map(string)
  description = "Map of tags for resource"
}

variable "resource_group_name_kv" {
  type        = string
  description = "The resource group of the Azure Key Vault containing all required secrets and certificates."
}

variable "key_vault_name" {
  type        = string
  description = "Azure Key Vault name containing all required secrets and certificates."
}

variable "proxy_key_secret_name" {
  type        = string
  description = "Name of the secret under which the proxy cert key is stored in the Azure Key Vault."
}

variable "proxy_cert_secret_name" {
  type        = string
  description = "Name of the secret under which the proxy cert is stored in the Azure Key Vault."
}