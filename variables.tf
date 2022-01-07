# General
# -------
variable "friendly_name_prefix" {
  type        = string
  description = "(Required) Name prefix used for resources"
}

variable "domain_name" {
  default     = null
  type        = string
  description = "(Required) Domain to create Terraform Enterprise subdomain within"
}

variable "tfe_subdomain" {
  default     = null
  type        = string
  description = "Subdomain for TFE"
}

# DNS
# ---
variable "dns_create_record" {
  default     = true
  type        = bool
  description = "If true, will create a DNS record. If false, no record will be created and IP of load balancer will instead be output."
}

variable "dns_external_fqdn" {
  default     = null
  type        = string
  description = "External DNS FQDN should be supplied if dns_create_record is false"
}

# Provider
# --------
variable "location" {
  default     = "East US"
  type        = string
  description = "(Required) Azure location name e.g. East US"
}

variable "zones" {
  default     = ["1", "2", "3"]
  type        = list(string)
  description = "Azure zones to use for applicable resources"
}

variable "resource_group_name" {
  default     = null
  type        = string
  description = "(Required) Azure resource group name"
}

variable "resource_group_name_dns" {
  default     = null
  type        = string
  description = "Name of resource group which contains desired DNS zone"
}

# Bastion
# -------
variable "create_bastion" {
  default     = true
  type        = bool
  description = "If true, will create Azure Bastion PaaS and required resources https://azure.microsoft.com/en-us/services/azure-bastion/"
}

# Network
# -------
variable "network_private_subnet_id" {
  default     = null
  type        = string
  description = "(Optional) Existing network private subnet ID"
}

variable "network_frontend_subnet_id" {
  default     = null
  type        = string
  description = "(Optional) Existing network frontend subnet ID"
}

variable "network_bastion_subnet_id" {
  default     = null
  type        = string
  description = "(Optional) Existing network Bastion subnet ID"
}

variable "network_redis_subnet_id" {
  default     = null
  type        = string
  description = "(Optional) Existing network Redis subnet ID"
}

variable "network_database_subnet_id" {
  default     = null
  type        = string
  description = "The identity of an existing database subnetwork."
}

variable "network_database_private_dns_zone_id" {
  default     = null
  type        = string
  description = "The identity of an existing private DNS zone for the database."
}

variable "network_cidr" {
  default     = "10.0.0.0/16"
  type        = string
  description = "(Optional) CIDR range for network"
}

variable "network_private_subnet_cidr" {
  default     = "10.0.32.0/20"
  type        = string
  description = "(Optional) Subnet CIDR range for TFE"
}

variable "network_frontend_subnet_cidr" {
  default     = "10.0.0.0/20"
  type        = string
  description = "(Optional) Subnet CIDR range for frontend"
}

variable "network_bastion_subnet_cidr" {
  default     = "10.0.16.0/20"
  type        = string
  description = "(Optional) Subnet CIDR range for Bastion"
}

variable "network_redis_subnet_cidr" {
  default     = "10.0.48.0/20"
  type        = string
  description = "(Optional) Subnet CIDR range for Redis"
}

variable "network_database_subnet_cidr" {
  default     = "10.0.64.0/20"
  type        = string
  description = "The CIDR range of the database subnetwork."
}

variable "network_allow_range" {
  default     = "*"
  type        = string
  description = "(Optional) Network range to allow access to TFE"
}

# TFE License
# -----------
variable "tfe_license_secret" {
  type = object({
    id = string
  })
  description = "The Key Vault secret under which the Base64 encoded TFE license is stored."
}

# Object Storage
# --------------
variable "storage_account_name" {
  default     = null
  type        = string
  description = "Storage account name"
}

variable "storage_account_key" {
  default     = null
  type        = string
  description = "Storage account key"
}

variable "storage_account_container_name" {
  default     = null
  type        = string
  description = "Storage account container name"
}

variable "storage_account_primary_blob_connection_string" {
  default     = null
  type        = string
  description = "Storage account primary blob endpoint"
}

# Service Accounts
# ----------------
variable "storage_account_tier" {
  default     = "Standard"
  type        = string
  description = "Storage account tier Standard or Premium"
}

variable "storage_account_replication_type" {
  default     = "ZRS"
  type        = string
  description = "Storage account type LRS, GRS, RAGRS, ZRS"
}

# Database
# --------
variable "database_user" {
  default     = "tfeuser"
  type        = string
  description = "Postgres username"
}

variable "database_machine_type" {
  default     = "GP_Standard_D4s_v3"
  type        = string
  description = "Postgres sku short name: tier + family + cores"
}

variable "database_size_mb" {
  default     = 32768
  type        = number
  description = "Postgres storage size in MB"
}

variable "database_version" {
  default     = 12
  type        = number
  description = "Postgres version"
}

variable "database_backup_retention_days" {
  default     = 7
  type        = number
  description = "Backup retention days for the PostgreSQL server."

  validation {
    condition = (
      var.database_backup_retention_days >= 7 &&
      var.database_backup_retention_days <= 35
    )

    error_message = "Supported values for database_backup_retention_days are between 7 and 35 days."
  }
}

variable "database_availability_zone" {
  default     = 1
  type        = number
  description = "The Availability Zone of the PostgreSQL Flexible Server."

  validation {
    condition = (
      var.database_availability_zone == 1 ||
      var.database_availability_zone == 2 ||
      var.database_availability_zone == 3
    )

    error_message = "Possible values for database_availability_zone are 1, 2 and 3."
  }
}

# Load Balancer
# -------------
variable "load_balancer_type" {
  default     = "application_gateway"
  type        = string
  description = "Expected value of 'application_gateway' or 'load_balancer'"

  validation {
    condition = (
      var.load_balancer_type == "application_gateway" ||
      var.load_balancer_type == "load_balancer"
    )

    error_message = "The load_balancer_type value must be 'application_gateway' or 'load_balancer'."
  }
}

variable "load_balancer_public" {
  default     = true
  type        = bool
  description = "Load balancer will use public IP if true"
}

variable "load_balancer_sku_name" {
  default     = "Standard_v2"
  type        = string
  description = "The Name of the SKU to use for Application Gateway, Standard_v2 or WAF_v2 accepted"

  validation {
    condition = (
      var.load_balancer_sku_name == "Standard_v2" ||
      var.load_balancer_sku_name == "WAF_v2"
    )

    error_message = "The load_balancer_sku_name value must be 'Standard_v2' or 'WAF_v2'."
  }
}

variable "load_balancer_sku_tier" {
  default     = "Standard_v2"
  type        = string
  description = "The Tier of the SKU to use for Application Gateway, Standard_v2 or WAF_v2 accepted"

  validation {
    condition = (
      var.load_balancer_sku_tier == "Standard_v2" ||
      var.load_balancer_sku_tier == "WAF_v2"
    )

    error_message = "The load_balancer_sku_tier value must be 'Standard_v2' or 'WAF_v2'."
  }
}

variable "load_balancer_waf_firewall_mode" {
  default     = "Prevention"
  type        = string
  description = "The Web Application Firewall mode (Detection or Prevention)"
}

variable "load_balancer_waf_rule_set_version" {
  default     = "3.1"
  type        = string
  description = "The Version of the Rule Set used for this Web Application Firewall. Possible values are 2.2.9, 3.0, and 3.1."
}

variable "load_balancer_waf_file_upload_limit_mb" {
  default     = 100
  type        = number
  description = "The File Upload Limit in MB. Accepted values are in the range 1MB to 750MB for the WAF_v2 SKU, and 1MB to 500MB for all other SKUs. Defaults to 100MB."
}

variable "load_balancer_waf_max_request_body_size_kb" {
  default     = 128
  type        = number
  description = "The Maximum Request Body Size in KB. Accepted values are in the range 1KB to 128KB. Defaults to 128KB."
}

# Redis
# -----
variable "redis_family" {
  default     = "P"
  type        = string
  description = "(Required) The SKU family/pricing group to use. Valid values are C (for Basic/Standard SKU family) and P (for Premium)"
}

variable "redis_sku_name" {
  default     = "Premium"
  type        = string
  description = "(Required) The SKU of Redis to use. Possible values are Basic, Standard and Premium."
}

variable "redis_size" {
  default     = "3"
  type        = string
  description = "The size of the Redis cache to deploy. Valid values for a SKU family of C (Basic/Standard) are 0, 1, 2, 3, 4, 5, 6, and for P (Premium) family are 1, 2, 3, 4."
}

variable "redis_enable_non_ssl_port" {
  default     = false
  type        = bool
  description = "Enable the non-SSL port (6379)"
}

variable "redis_enable_authentication" {
  default     = true
  type        = bool
  description = "If set to false, the Redis instance will be accessible without authentication. enable_authentication can only be set to false if a subnet_id is specified; and only works if there aren't existing instances within the subnet with enable_authentication set to true."
}

variable "redis_rdb_backup_enabled" {
  default     = false
  type        = bool
  description = "(Optional) Is Backup Enabled? Only supported on Premium SKU's. If rdb_backup_enabled is true and redis_rdb_storage_connection_string is null, a new, Premium storage account will be created."
}

variable "redis_rdb_backup_frequency" {
  default     = null
  type        = number
  description = "(Optional) The Backup Frequency in Minutes. Only supported on Premium SKU's. Possible values are: 15, 30, 60, 360, 720 and 1440."
}

variable "redis_rdb_backup_max_snapshot_count" {
  default     = null
  type        = number
  description = "(Optional) The maximum number of snapshots to create as a backup. Only supported for Premium SKU's."
}

variable "redis_rdb_existing_storage_account" {
  default     = null
  type        = string
  description = "(Optional) Name of an existing Premium Storage Account for data encryption at rest. If value is null, a new, Premium storage account will be created."
}

variable "redis_rdb_existing_storage_account_rg" {
  default     = null
  type        = string
  description = "(Optional) Name of the resource group that contains the existing Premium Storage Account for data encryption at rest."
}

# VM
# --
variable "vm_node_count" {
  default     = 2
  type        = number
  description = "The number of instances to create for TFE environment"

  validation {
    condition     = var.vm_node_count <= 5
    error_message = "The vm_node_count value must be less than or equal to 5."
  }
}

variable "vm_user" {
  default     = "tfeuser"
  type        = string
  description = "Virtual machine user name"
}

variable "vm_public_key" {
  default     = null
  type        = string
  description = "Virtual machine public key for authentication (2048-bit ssh-rsa)"
}

variable "vm_image_id" {
  default     = "ubuntu"
  type        = string
  description = "Virtual machine image id - may be 'ubuntu' (default), 'rhel', or custom image resource id"

  validation {
    condition = (
      var.vm_image_id == "ubuntu" ||
      var.vm_image_id == "rhel" ||
      substr(var.vm_image_id, 0, 14) == "/subscriptions"
    )

    error_message = "The vm_image_id value must be 'ubuntu', 'rhel', or an Azure image resource ID beginning with \"/subscriptions\"."
  }
}

variable "vm_sku" {
  default     = "Standard_D4_v3"
  type        = string
  description = "Azure virtual machine sku"
}

variable "vm_os_disk_disk_size_gb" {
  default     = 100
  type        = number
  description = "The size of the Data Disk which should be created"
}

variable "vm_vmss_scale_in_policy" {
  default     = "Default"
  type        = string
  description = "The scale-in policy to use for the virtual machine scale set."

  validation {
    condition = (
      var.vm_vmss_scale_in_policy == "Default" ||
      var.vm_vmss_scale_in_policy == "NewestVM" ||
      var.vm_vmss_scale_in_policy == "OldestVM"
    )

    error_message = "The vm_vmss_scale_in_policy value must be 'Default', 'NewestVM', or 'OldestVM'."
  }
}

# User Data
# ---------
variable "user_data_installation_type" {
  default     = "production"
  type        = string
  description = "Installation type for Terraform Enterprise"

  validation {
    condition = (
      var.user_data_installation_type == "poc" ||
      var.user_data_installation_type == "production"
    )

    error_message = "The installation type must be 'production' (recommended) or 'poc' (only used for demo-mode proofs of concept)."
  }
}

variable "user_data_release_sequence" {
  default     = null
  type        = string
  description = "Terraform Enterprise release sequence"
}

variable "user_data_redis_use_tls" {
  default     = true
  type        = bool
  description = "Boolean to determine if TLS should be used"
}

variable "user_data_iact_subnet_list" {
  default     = []
  description = <<-EOD
  A list of IP address ranges which will be authorized to access the IACT. The ranges must be expressed
  in CIDR notation.
  EOD
  type        = list(string)
}

variable "user_data_trusted_proxies" {
  default     = []
  description = <<-EOD
  A list of IP address ranges which will be considered safe to ignore when evaluating the IP addresses of requests like
  those made to the IACT endpoint.
  EOD
  type        = list(string)
}

# TLS Certificates
# ----------------
variable "ca_certificate_secret" {
  default = null
  type = object({
    id           = string
    key_vault_id = string
    name         = string
    value        = string
  })
  description = <<-EOD
  A Key Vault secret which contains the Base64 encoded version of a PEM encoded public certificate of a
  certificate authority (CA) to be trusted by the Virtual Machine Scale Set and the Application Gateway. This argument
  is only required if TLS certificates in the deployment are not issued by a well-known CA.
  EOD
}

variable "load_balancer_certificate" {
  default = null
  type = object({
    key_vault_id = string
    name         = string
    secret_id    = string
  })
  description = "A Key Vault Certificate to be attached to the Application Gateway."
}

variable "vm_certificate_secret" {
  default = null
  type = object({
    key_vault_id = string
    id           = string
  })
  description = <<-EOD
  A Key Vault secret which contains the Base64 encoded version of a PEM encoded public certificate for the Virtual
  Machine Scale Set.
  EOD
}

variable "vm_key_secret" {
  default = null
  type = object({
    key_vault_id = string
    id           = string
  })
  description = <<-EOD
  A Key Vault secret which contains the Base64 encoded version of a PEM encoded private key for the Virtual Machine
  Scale Set.
  EOD
}

# Proxy
# -----
variable "proxy_ip" {
  default     = null
  type        = string
  description = "IP Address of the proxy server"
}

variable "proxy_port" {
  default     = null
  type        = string
  description = "Port that the proxy server will use"
}

# Tagging
# -------
variable "tags" {
  default     = {}
  type        = map(string)
  description = "Map of tags for resource"
}
