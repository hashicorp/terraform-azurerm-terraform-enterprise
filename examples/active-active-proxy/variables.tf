variable "bastion_public_ssh_key_secret_name" {
  type        = string
  description = "The name of the public SSH key secret for the bastion."
}

variable "ca_certificate_secret_name" {
  type        = string
  description = <<-EOD
  The name of a Key Vault secret which contains the Base64 encoded version of a PEM encoded public certificate of a
  certificate authority (CA) to be trusted by the Virtual Machine Scale Set.
  EOD
}

variable "ca_key_secret_name" {
  type        = string
  description = <<-EOD
  The name of a Key Vault secret which contains the Base64 encoded version of a PEM encoded private key of a
  certificate authority (CA).
  EOD
}

variable "domain_name" {
  type        = string
  description = "Domain to create Terraform Enterprise subdomain within"
}

variable "key_vault_id" {
  type        = string
  description = "The identity of the Key Vault which contains secrets and certificates."
}

variable "license_file" {
  type        = string
  description = "The local path to the Terraform Enterprise license to be provided by CI."
}

variable "location" {
  type        = string
  description = "Azure location name e.g. East US"
}

variable "network_allow_range" {
  default     = "*"
  type        = string
  description = "Network range to allow access to bastion vm"
}

variable "proxy_public_ssh_key_secret_name" {
  type        = string
  description = "The name of the public SSH key secret for the proxy."
}

variable "resource_group_name_dns" {
  type        = string
  description = "Name of resource group which contains desired DNS zone"
}

variable "tags" {
  default     = {}
  type        = map(string)
  description = "Map of tags for resource"
}

variable "vm_certificate_secret_name" {
  type        = string
  description = <<-EOD
  The name of a Key Vault secret which contains the Base64 encoded version of a PEM encoded public certificate of a
  certificate authority (CA) to be trusted by the Virtual Machine Scale Set.
  EOD
}

variable "vm_key_secret_name" {
  type        = string
  description = <<-EOD
  The name of a Key Vault secret which contains the Base64 encoded version of a PEM encoded private key of a
  certificate authority (CA) to be trusted by the Virtual Machine Scale Set.
  EOD
}