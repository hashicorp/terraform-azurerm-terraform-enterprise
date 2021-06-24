# Domain
# ------

variable "domain_name" {
  type        = string
  description = "Domain to create Terraform Enterprise subdomain within"
}

variable "resource_group_name_dns" {
  type        = string
  description = "Name of resource group which contains desired DNS zone"
}

# Key Vault and Certificate
# -------------------------

variable "resource_group_name_kv" {
  type        = string
}

variable "key_vault_name" {
  type        = string
  description = "Azure Key Vault name containing required certificate"
}

variable "certificate_name" {
  type        = string
  description = "Azure Key Vault Certificate name for Application Gateway"
}


# Bootstrap Resources Storage Account
# -----------------------------------

variable "resource_group_name_bootstrap" {
  type        = string
  description = "The resource group of the storage account that houses the TFE license"
}

variable "bootstrap_storage_account_name" {
  type        = string
  description = "The name of the storage account that houses the TFE license"
}

variable "bootstrap_storage_account_container_name" {
  type        = string
  description = "The name of the container that houses the TFE license"
}
