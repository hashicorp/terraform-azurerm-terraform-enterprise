# ============================================================ REQUIRED

variable "install_id" {
  type        = "string"
  description = "A prefix to use for resource names"
}

variable "rg_name" {
  type        = "string"
  description = "The Azure Resource Group to build into"
}

variable "vnet_name" {
  type        = "string"
  description = "The Azure Virtual Network to build into"
}

variable "subnet_name" {
  type        = "string"
  description = "The Azure Virtual Network Subnet to build into"
}

variable "dns" {
  type        = "map"
  description = "Expects key: [rg_name]"
}

variable "key_vault" {
  type        = "map"
  description = "Expects keys: [name, rg_name] (key_vault name and Azure resource group that key vault resides in.)"
}

variable "tls" {
  type        = "map"
  description = "Expects keys: [pfx_cert, pfx_cert_pw] (the path to a pfx certificate for the dns zone, the password for that certificate)"
}

variable "resource_prefix" {
  type        = "string"
  description = "Prefix name for resources"
}

variable "key_type" {
  type        = "string"
  description = "Type of key-pair used to generate the provided certificate"
}

variable "key_size" {
  type        = "string"
  description = "Byte size for the key-pair used to generate the provided certificate"
}

# ============================================================ MISC

locals {
  # path.root for remote modules to work properly.

  ssh_public_key_path     = "${path.root}/work"
  key_name                = "${var.resource_prefix}-${var.install_id}"
  public_key_filename     = "${local.ssh_public_key_path}/${local.key_name}.pub"
  private_key_filename    = "${local.ssh_public_key_path}/${local.key_name}.priv"
  prefix                  = "${var.resource_prefix}-${var.install_id}"
  rendered_kv_rg_name     = "${coalesce(var.key_vault["rg_name"], var.rg_name)}"
  rendered_domain_rg_name = "${coalesce(var.dns["rg_name"], var.rg_name)}"
}
