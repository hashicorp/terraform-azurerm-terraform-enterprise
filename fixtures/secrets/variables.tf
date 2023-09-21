# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# Key Vault
# ---------
variable "key_vault_id" {
  type        = string
  description = "The identity of the Key Vault which contains secrets and certificates."
}

# Secrets
# -------
variable "tfe_license" {
  default = null
  type = object({
    name = string
    path = string
  })
  description = "A map that consists of the newly created secret name and the local path to the Terraform Enterprise license."
}

variable "private_key_pem" {
  default = null
  type = object({
    name  = string
    value = string
  })
  description = "A map that consists of the newly created secret name and its value. This secret will be used for the vm_key_secret variable in the root module."
}

variable "chained_certificate_pem" {
  default = null
  type = object({
    name  = string
    value = string
  })
  description = "A map that consists of the newly created secret name and its value. This secret will be used for the vm_certificate_secret variable in the root module."
}

variable "proxy_public_key" {
  default = null
  type = object({
    name  = string
    value = string
  })
  description = "A map that consists of the newly created secret name and its value. This secret will be used for the SSH public_key argument when creating the proxy virtual machine."
}

variable "proxy_private_key" {
  default = null
  type = object({
    name  = string
    value = string
  })
  description = "A map that consists of the newly created secret name and its value. This secret will be used for the SSH private key of the proxy virtual machine."
}

variable "ca_certificate" {
  default = null
  type = object({
    name  = string
    value = string
  })
  description = "A map that consists of the newly created secret name and its value. This secret value is the Base64 encoded version of a PEM encoded public certificate of a certificate authority (CA)."
}

variable "ca_private_key" {
  default = null
  type = object({
    name  = string
    value = string
  })
  description = "A map that consists of the newly created secret name and its value. This secret value is the Base64 encoded version of a PEM encoded private key of a certificate authority (CA)."
}

variable "bastion_public_key" {
  default = null
  type = object({
    name  = string
    value = string
  })
  description = "A map that consists of the newly created secret name and its value. This secret will be used for the SSH public key of the bastion virtual machine, should you choose to create one outside of the module."
}

variable "bastion_private_key" {
  default = null
  type = object({
    name  = string
    value = string
  })
  description = "A map that consists of the newly created secret name and its value. This secret will be used for the SSH private key of the bastion virtual machine, should you choose to create one outside of the module."
}

# Tagging
# -------
variable "tags" {
  default     = {}
  type        = map(string)
  description = "Map of tags for resource"
}
