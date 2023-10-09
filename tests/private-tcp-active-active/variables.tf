# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "bastion_public_ssh_key_secret_name" {
  type        = string
  description = "The name of the public SSH key secret for the bastion."
}

variable "ca_certificate_secret_name" {
  type        = string
  description = "The name of a Key Vault secret which contains the Base64 encoded version of a PEM encoded public certificate of a certificate authority (CA) to be trusted by the Virtual Machine Scale Set."
}

variable "ca_key_secret_name" {
  type        = string
  description = "The name of a Key Vault secret which contains the Base64 encoded version of a PEM encoded private key of a certificate authority (CA)."
}

variable "consolidated_services_enabled" {
  default     = true
  type        = bool
  description = "(Required) True if TFE uses consolidated services."
}

variable "domain_name" {
  type        = string
  description = "Domain to create Terraform Enterprise subdomain within"
}

variable "hc_license" {
  default     = null
  type        = string
  description = "(Not needed if is_replicated_deployment is true) The raw TFE license that is validated on application startup."
}

variable "is_replicated_deployment" {
  type        = bool
  description = "TFE will be installed using a Replicated license and deployment method."
  default     = true
}

variable "location" {
  type        = string
  description = "Azure location name e.g. East US"
}

variable "key_vault_id" {
  type        = string
  description = "The identity of the Key Vault which contains secrets and certificates."
}

variable "network_allow_range" {
  default     = null
  type        = string
  description = "Network range to allow access to bastion vm"
}

variable "proxy_public_ssh_key_secret_name" {
  type        = string
  description = "The name of the public SSH key secret for the proxy."
}

variable "registry_username" {
  default     = null
  type        = string
  description = "(Not needed if is_replicated_deployment is true) The username for the docker registry from which to source the terraform_enterprise container images."
}

variable "registry_password" {
  default     = null
  type        = string
  description = "(Not needed if is_replicated_deployment is true) The password for the docker registry from which to source the terraform_enterprise container images."
}

variable "resource_group_name_dns" {
  type        = string
  description = "Name of resource group which contains desired DNS zone"
}

variable "tfe_image_tag" {
  default     = "latest"
  type        = string
  description = "(Not needed if is_replicated_deployment is true) The image version of the terraform-enterprise image (e.g. \"1234567\")"
}

variable "tfe_license_secret_name" {
  default     = null
  type        = string
  description = "Name of the secret under which the Base64 encoded TFE license is stored in the Azure Key Vault"
}

variable "vm_certificate_secret_name" {
  type        = string
  description = "The name of a Key Vault secret which contains the Base64 encoded version of a PEM encoded public certificate of a certificate authority (CA) to be trusted by the Virtual Machine Scale Set."
}

variable "vm_key_secret_name" {
  type        = string
  description = "The name of a Key Vault secret which contains the Base64 encoded version of a PEM encoded private key of a certificate authority (CA) to be trusted by the Virtual Machine Scale Set."
}
