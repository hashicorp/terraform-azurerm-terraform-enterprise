variable "resource_group_name_bootstrap" {
  type        = string
  description = "Azure resource group name for bootstrap"
}

variable "bootstrap_storage_account_name" {
  type        = string
  description = "The name of the storage account in which the container that houses the TFE license."
}

variable "bootstrap_storage_account_container_name" {
  type        = string
  description = "The name of the container that houses the TFE license."
}
