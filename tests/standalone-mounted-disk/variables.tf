variable "domain_name" {
  type        = string
  default     = "team-private-terraform-enterprise.azure.ptfedev.com"
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

variable "resource_group_name_dns" {
  type        = string
  default     = "ptfedev-com-dns-tls"
  description = "Name of resource group which contains desired DNS zone"
}
