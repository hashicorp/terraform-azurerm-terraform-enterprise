# Provider
# --------
variable "location" {
  type        = string
  description = "(Required) Azure location name e.g. East US"
}

variable "resource_group_name" {
  type        = string
  description = "(Required) Azure resource group name"
}

# Redis
# -----
variable "redis_subnet_id" {
  type        = string
  description = "(Required) Network subnet id for redis"
}

variable "redis" {
  type = object({
    family                          = string
    sku_name                        = string
    size                            = string
    enable_non_ssl_port             = bool
    use_password_auth               = bool
    rdb_backup_enabled              = bool
    rdb_backup_frequency            = number
    rdb_backup_max_snapshot_count   = number
    rdb_existing_storage_account    = string
    rdb_existing_storage_account_rg = string
    minimum_tls_version             = string
  })
  description = <<-EOD
  family                          - The SKU family/pricing group to use. Valid values are "C" (for Basic/Standard SKU family) and "P" (for Premium)
  sku_name                        - The SKU of Redis to use. Possible values are "Basic", "Standard", and "Premium".
  size                            - The size of the Redis cache to deploy. Valid values for a SKU family of C (Basic/Standard) are "0", "1", "2", "3", "4", "5", "6", and for P (Premium) family are "1", "2", "3", "4".
  enable_non_ssl_port             - Boolean to determine whether or not to enable the non-SSL port (6379)
  use_password_auth               - If set to false, the Redis instance will be accessible without authentication. use_password_auth can only be set to false if a subnet_id is specified; and only works if there aren't existing instances within the subnet with use_password_auth set to true.
  rdb_backup_enabled              - Is Backup Enabled? Only supported on Premium SKU's. If rdb_backup_enabled is true and redis_rdb_storage_connection_string is null, a new, Premium storage account will be created.
  rdb_backup_frequency            - The Backup Frequency in Minutes. Only supported on Premium SKU's. Possible values are: 15, 30, 60, 360, 720 and 1440.
  rdb_backup_max_snapshot_count   - The maximum number of snapshots to create as a backup. Only supported for Premium SKU's.
  rdb_existing_storage_account    - Name of an existing Premium Storage Account for data encryption at rest. If value is null, a new, Premium storage account will be created.
  rdb_existing_storage_account_rg - Name of the resource group that contains the existing Premium Storage Account for data encryption at rest.
  minimum_tls_version             - The minimum TLS version. "1.2" is suggested.
  EOD
}

# Tagging
# -------
variable "tags" {
  default     = {}
  type        = map(string)
  description = "Map of tags for resource"
}
