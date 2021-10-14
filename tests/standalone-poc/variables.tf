variable "key_vault_id" {
  type        = string
  description = "The identity of the Key Vault which contains secrets and certificates."
}

variable "iact_subnet_list" {
  default     = []
  description = <<-EOD
  A list of IP address ranges which will be authorized to access the IACT. The ranges must be expressed
  in CIDR notation.
  EOD
  type        = list(string)
}

variable "license_file" {
  type        = string
  description = "The local path to the Terraform Enterprise license to be provided by CI."
}