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

variable "certificate_name" {
  type        = string
  description = "Azure Key Vault Certificate name for CA Cert and provided for Replicated TlsBootstrapCert setting"
}

variable "tfe_license_secret_name" {
  type        = string
  description = "Name of the secret under which the Base64 encoded TFE license is stored in the Azure Key Vault"
}

variable "tls_bootstrap_cert_secret_name" {
  type        = string
  description = <<-EOD
  (optional) Value to be provided for Replicated's TlsBootstrapCert setting. If a trusted Azure Key Vault 
  Certificate is used as the TlsBootstrapCert via the tls_certificate_name variable (this can be the same
  certificate as ca_certificate_name), then tls_bootstrap_cert_secret_name and tls_bootstrap_key_secret_name
  are not needed. However, if you want to use a different certificate or if you need to add an intermediate,
  then using this variable will allow the TFE instance(s) to pull that secret from Key Vault and use it in
  TFE.
  EOD
}

variable "tls_bootstrap_key_secret_name" {
  type        = string
  description = <<-EOD
  (optional) Value to be provided for Replicated's TlsBootstrapKey setting. If a trusted Azure Key Vault 
  Certificate is used as the TlsBootstrapKey via the tls_certificate_name variable (this can be the same
  certificate as ca_certificate_name), then tls_bootstrap_cert_secret_name and tls_bootstrap_key_secret_name
  are not needed. However, if you want to use a different certificate/key pair, then using this variable
  will allow the TFE instance(s) to pull that secret from Key Vault and use it in TFE.
  EOD
}


# User Data
# ---------
variable "iact_subnet_list" {
  default     = []
  description = <<-EOD
  A list of IP address ranges which will be authorized to access the IACT. The ranges must be expressed
  in CIDR notation.
  EOD
  type        = list(string)
}
