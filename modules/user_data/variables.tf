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

variable "user_data_tfe_license_name" {
  type        = string
  description = "Terraform Enterprise license file name"
}

variable "tfe_license_secret_name" {
  type        = string
  description = "Name of the secret under which the Base64 encoded Terraform Enterprise license is (or will be) stored in the Azure Key Vault."
}

variable "user_data_ca" {
  type        = string
  description = "(optional) Value to be provided for TFE ca_cert setting"
}

variable "user_data_cert" {
  type        = string
  description = "(optional) Value to be provided for Replicated TlsBootstrapCert setting"
}

variable "user_data_cert_key" {
  type        = string
  description = "(optional) Value to be provided for Replicated TlsBootstrapKey setting"
}

# Proxy
# -----
variable "key_vault_name" {
  type        = string
  description = "Azure Key Vault name containing all required secrets and certificates."
}

variable "proxy_ip" {
  type        = string
  description = "IP Address of the proxy server"
}

variable "proxy_port" {
  default = "3128"
  type    = string
}

variable "proxy_cert_name" {
  type        = string
  description = "Name for the stored proxy certificate bundle"
}

variable "proxy_cert_secret_name" {
  type        = string
  description = "Name of the secret under which the proxy cert is stored in the Azure Key Vault"
}

variable "no_proxy" {
  default     = []
  type        = list(string)
  description = "Addresses which should not be accessed through the proxy server located at proxy_ip. This list will be combined with internal GCP addresses."
}
