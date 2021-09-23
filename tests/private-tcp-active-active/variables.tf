# General
# -------
variable "location" {
  type        = string
  description = "Azure location name e.g. East US"
}

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
  description = "The resource group of the Azure Key Vault containing all required secrets and certificates"
}

variable "key_vault_name" {
  type        = string
  description = "Azure Key Vault name containing all required secrets and certificates"
}

variable "tfe_license_secret_name" {
  type        = string
  description = "Name of the secret under which the Base64 encoded TFE license is stored in the Azure Key Vault"
}

variable "wildcard_chained_certificate_pem_secret_name" {
  type        = string
  description = <<-EOD
  Value to be provided for Replicated's TlsBootstrapCert setting. If a trusted Azure Key Vault
  Certificate is used as the TlsBootstrapCert via the certificate_name variable (this can be the same
  certificate as certificate_name), then tfe_bootstrap_cert_secret_name and tfe_bootstrap_key_secret_name
  are not needed. However, if you want to use a different certificate or if you need to add an intermediate,
  then using this variable will allow the TFE instance(s) to pull that secret from Key Vault and use it in
  TFE.
  EOD
}

variable "wildcard_private_key_pem_secret_name" {
  type        = string
  description = <<-EOD
  Value to be provided for Replicated's TlsBootstrapKey setting. If a trusted Azure Key Vault
  Certificate is used as the TlsBootstrapKey via the certificate_name variable (this can be the same
  certificate as certificate_name), then tfe_bootstrap_cert_secret_name and tfe_bootstrap_key_secret_name
  are not needed. However, if you want to use a different certificate/key pair, then using this variable
  will allow the TFE instance(s) to pull that secret from Key Vault and use it in TFE.
  EOD
}

# Proxy & Bastion
# ---------------
variable "ca_private_key_secret_name" {
  type        = string
  description = "Name of the secret under which the CA private key for the mitmproxy is stored in the Azure Key Vault"
}

variable "ca_cert_secret_name" {
  type        = string
  description = "Name of the secret under which the CA certificate for the mitmproxy is stored in the Azure Key Vault"
}

variable "proxy_public_key" {
  type        = string
  description = "The public SSH key for the proxy."
}

variable "bastion_public_key" {
  type        = string
  description = "The public SSH key for the bastion."
}

variable "network_allow_range" {
  type        = string
  description = "Network range to allow access to bastion vm"
}
