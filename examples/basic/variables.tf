variable "resource_group" {
  description = "Azure resource group the vnet, key vault, and dns domain exist in."
}

variable "vnet_name" {
  description = "Azure virtual network name to deploy in."
}

variable "subnet_name" {
  description = "Azure subnet within the virtual network to deploy in."
}

variable "dns_domain" {
  description = "Azure hosted DNS domain"
}

variable "key_vault_name" {
  description = "Azure hosted Key Vault resource."
}

variable "certificate_path" {
  description = "Path to a TLS wildcard certificate for the domain in PKCS12 format."
}

variable "certificate_pass" {
  description = "The Password for the PKCS12 Certificate."
}

variable "license_path" {
  description = "Path to the RLI lisence file for Terraform Enterprise."
}
