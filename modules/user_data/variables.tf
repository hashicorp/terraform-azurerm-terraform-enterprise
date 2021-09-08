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
variable "key_vault_name" {
  type        = string
  description = "Azure Key Vault name containing all required secrets and certificates"
}

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
  description = "Name of the secret under which the Base64 encoded Terraform Enterprise license is (or will be) stored in the Azure Key Vault"
}

variable "user_data_ca" {
  type        = string
  description = <<-EOD
  (Optional) Value to be provided for TFE ca_cert setting. A custom Certificate Authority
  certificate bundle to be used for authenticating connections with Terraform Enterprise.
  EOD
}

variable "user_data_use_kv_secrets" {
  type        = string
  description = <<-EOD
  If 1, then TFE will retrieve the secrets named in the tfe_bootstrap_cert_secret_name and
  tls_bootstrap_cert_key_name variables during its install script. If 0, the retrieval will
  be skipped.
  EOD
}

variable "user_data_tfe_bootstrap_cert_name" {
  type        = string
  description = "Value to be provided for Replicated TlsBootstrapCert setting"
}

variable "user_data_tfe_bootstrap_key_name" {
  type        = string
  description = "Value to be provided for Replicated TlsBootstrapKey setting"
}

variable "user_data_iact_subnet_list" {
  default     = []
  type        = list(string)
  description = <<-EOD
  A list of IP address ranges which will be authorized to access the IACT. The ranges must be expressed
  in CIDR notation.
  EOD
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
