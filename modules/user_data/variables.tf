# General
# -------
variable "fqdn" {
  type        = string
  description = "The fully qualified domain name for the TFE environment"
}

variable "active_active" {
  default     = true
  type        = bool
  description = "True if TFE running in active-active configuration"
}

# Database
# --------
variable "user_data_pg_dbname" {
  type        = string
  description = "Postgres database name"
}

variable "user_data_pg_netloc" {
  type        = string
  description = "Postgres database fqdn and port"
}

variable "user_data_pg_user" {
  type        = string
  description = "Postgres database username"
}

variable "user_data_pg_password" {
  type        = string
  description = "Postgres database password"
}

# Redis
# -----
variable "redis_enable_authentication" {
  default     = true
  type        = bool
  description = "If set to false, the Redis instance will be accessible without authentication."
}

variable "user_data_redis_host" {
  type        = string
  description = "Redis hostname"
}

variable "user_data_redis_port" {
  default     = "6380"
  type        = string
  description = "Redis port to use for communication"
}

variable "user_data_redis_pass" {
  type        = string
  description = "Redis password"
}

variable "user_data_redis_use_tls" {
  default     = true
  type        = bool
  description = "Boolean to determine if TLS should be used"
}

# Azure
# -----
variable "user_data_azure_container_name" {
  type        = string
  description = "Azure storage container name"
}

variable "user_data_azure_account_key" {
  type        = string
  description = "Azure storage account key"
}

variable "user_data_azure_account_name" {
  type        = string
  description = "Azure storage account name"
}

# TFE
# ---
variable "user_data_release_sequence" {
  type        = string
  description = "Terraform Enterprise version release sequence"
}

variable "tfe_license_secret" {
  type = object({
    id = string
  })
  description = "The Key Vault secret under which the Base64 encoded Terraform Enterprise license is stored."
}

variable "ca_certificate_secret" {
  type = object({
    id = string
  })
  description = <<-EOD
  A Key Vault secret which contains the Base64 encoded version of a PEM encoded public certificate of a certificate
  authority (CA) to be trusted by the Virtual Machine Scale Set.
  EOD
}

variable "certificate_secret" {
  type = object({
    id = string
  })
  description = <<-EOD
  A Key Vault secret which contains the Base64 encoded version of a PEM encoded public certificate for the Virtual
  Machine Scale Set.
  EOD
}

variable "key_secret" {
  type = object({
    id = string
  })
  description = <<-EOD
  A Key Vault secret which contains the Base64 encoded version of a PEM encoded private key for the Virtual Machine
  Scale Set.
  EOD
}

variable "user_data_iact_subnet_list" {
  default     = []
  type        = list(string)
  description = <<-EOD
  A list of IP address ranges which will be authorized to access the IACT. The ranges must be expressed
  in CIDR notation.
  EOD
}

variable "user_data_installation_type" {
  type        = string
  description = "Installation type for Terraform Enterprise"

  validation {
    condition = (
      var.user_data_installation_type == "poc" ||
      var.user_data_installation_type == "production"
    )

    error_message = "The installation type must be 'production' (recommended) or 'poc' (only used for demo-mode)."
  }
}

variable "user_data_trusted_proxies" {
  description = <<-EOD
  A list of IP address ranges which will be considered safe to ignore when evaluating the IP addresses of requests like
  those made to the IACT endpoint.
  EOD
  type        = list(string)
}

# Proxy
# -----
variable "proxy_ip" {
  type        = string
  description = "IP Address of the proxy server"
}

variable "proxy_port" {
  default     = "3128"
  type        = string
  description = "Port that the proxy server will use"
}

variable "no_proxy" {
  default     = []
  type        = list(string)
  description = "Addresses which should not be accessed through the proxy server located at proxy_ip. This list will be combined with internal GCP addresses."
}
