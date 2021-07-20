# Object Storage
# --------------
variable "storage_account_name" {
  default     = null
  type        = string
  description = "Storage account name"
}

variable "storage_account_container_name" {
  default     = null
  type        = string
  description = "Storage account container name"
}
