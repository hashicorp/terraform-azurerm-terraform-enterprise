variable "key_vault_id" {
  type        = string
  description = "The identity of the Key Vault which contains secrets and certificates."
}

variable "license_file" {
  type        = string
  description = "The local path to the Terraform Enterprise license to be provided by CI."
}