
variable "bypass_preflight_checks" {
  default     = true
  type        = bool
  description = "Allow the TFE application to start without preflight checks."
}

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
  default     = null
  description = "The local path to the Terraform Enterprise license to be provided by CI."
}

variable "resource_group_name_dns" {
  type        = string
  default     = "ptfedev-com-dns-tls"
  description = "Name of resource group which contains desired DNS zone"
}

variable "tfe_license_secret_id" {
  default     = null
  type        = string
  description = "The Key Vault secret id under which the Base64 encoded Terraform Enterprise license is stored."
}

variable "vm_image_publisher" {
  type        = string
  description = <<-EOD
  The image publisher of the base image to install Terraform Enterprise on.  This is used in conjunction with
  vm_image_offer, vm_image_sku, and vm_image_version to determine the image to install from the public markeplace when
  vm_image_id is not provided.
  EOD
  default     = null
}

variable "vm_image_offer" {
  type        = string
  description = <<-EOD
  The image offer of the base image to install Terraform Enterprise on.  This is used in conjunction with
  vm_image_publisher, vm_image_sku, and vm_image_version to determine the image to install from the public markeplace
  when vm_image_id is not provided.
  EOD
  default     = null
}

variable "vm_image_sku" {
  type        = string
  description = <<-EOD
  The image sku of the base image to install Terraform Enterprise on.  This is used in conjunction with
  vm_image_publisher, vm_image_offer, and vm_image_version to determine the image to install from the public markeplace
  when vm_image_id is not provided.
  EOD
  default     = null
}

variable "vm_image_version" {
  type        = string
  description = <<-EOD
  The image version of the base image to install Terraform Enterprise on.  This is used in conjunction with
  vm_image_publisher, vm_image_offer, and vm_image_sku to determine the image to install from the public markeplace
  when vm_image_id is not provided.
  EOD
  default     = null
}

variable "distribution" {
  type        = string
  description = "(Required) What is the OS distribution of the instance on which Terraoform Enterprise will be deployed?"
  validation {
    condition     = contains(["rhel", "ubuntu"], var.distribution)
    error_message = "Supported values for distribution are 'rhel' or 'ubuntu'."
  }
  default = "ubuntu"
}