# General
# -------
variable "friendly_name_prefix" {
  type        = string
  description = "(Required) Name prefix used for resources"
}

variable "fqdn" {
  type        = string
  description = "DNS name (FQDN) identified by the Certificate"
}

# Provider
# --------
variable "location" {
  type        = string
  description = "Azure location name e.g. East US"
}

variable "tenant_id" {
  default     = null
  type        = string
  description = "The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault"
}

variable "object_id" {
  default     = null
  type        = string
  description = "The object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault. The object ID must be unique for the list of access policies."
}

# Key Vault
# ---------
variable "resource_group_name_kv" {
  type        = string
  description = "Name of resource group which contains desired key vault"
}

variable "key_vault_name" {
  type        = string
  description = "(recommended) Azure Key Vault name containing required certificate"
}

variable "certificate_permissions" {
  type        = list(string)
  description = "The list of permissions for the key vault certificates for the TFE instance"

  default = [
    "create",
    "delete",
    "get",
    "import",
    "list",
    "listissuers",
    "managecontacts",
    "manageissuers",
    "purge",
    "setissuers",
    "update",
  ]
}

variable "secret_permissions" {
  type        = list(string)
  description = "The list of permissions for the key vault secrets for the TFE instance"

  default = [
    "backup",
    "delete",
    "get",
    "list",
    "purge",
    "recover",
    "restore",
    "set",
  ]
}

# Certificate
# -----------
variable "certificate_name" {
  type        = string
  description = "(recommended) Azure Key Vault Certificate name for Application Gateway"
}

# TFE License
# -----------
variable "tfe_license_filepath" {
  default     = null
  type        = string
  description = "TFE License filepath"
}

variable "tfe_license_secret_name" {
  type        = string
  description = "Name of the secret under which the base64 encoded TFE license is to be stored in the Azure Key Vault"
}
