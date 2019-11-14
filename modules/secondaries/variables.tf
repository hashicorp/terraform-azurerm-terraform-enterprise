# === Required

variable "install_id" {
  type        = string
  description = "A prefix to use for resource names"
}

variable "rg_name" {
  type        = string
  description = "The Azure Resource Group to build into"
}

variable "location" {
  type        = string
  description = "The Azure Location to build into"
}

variable "subnet_id" {
  type        = string
  description = "The Azure Subnet to build into"
}

variable "ssh_public_key" {
  type        = string
  description = "The ssh public key to give to all vms in the scale-set for the local administrator account."
}

variable "username" {
  type        = string
  description = "Specifies the name of the local administrator account."
}

variable "cloud_init_data" {
  type        = string
  description = "Rendered cloud-init template to pass to the vms."
}

variable "storage_image" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  description = "Expects keys: [publisher, offer, sku, version]"
}

variable "vm" {
  type = object({
    count     = number
    size      = string
    size_tier = string
  })
  description = "Expects keys: [size, count, size_tier]"
}

variable "resource_prefix" {
  type        = string
  description = "Prefix name for resources"
}

# === Misc

locals {
  prefix = "${var.resource_prefix}-${var.install_id}"
}

