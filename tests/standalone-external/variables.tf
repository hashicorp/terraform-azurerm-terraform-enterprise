# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "bypass_preflight_checks" {
  default     = true
  type        = bool
  description = "Allow the TFE application to start without preflight checks."
}

variable "consolidated_services" {
  default     = false
  type        = bool
  description = "(Required) True if TFE uses consolidated services."
}

variable "database_version" {
  default     = 12
  type        = number
  description = "Postgres version"
}

variable "domain_name" {
  type        = string
  default     = "team-private-terraform-enterprise.azure.ptfedev.com"
  description = "Domain to create Terraform Enterprise subdomain within"
}

variable "hc_license" {
  default     = null
  type        = string
  description = "(Not needed if is_legacy_deployment is true) The raw TFE license that is validated on application startup."
}

variable "is_legacy_deployment" {
  type        = bool
  description = "TFE will be installed using a Replicated license and deployment method."
  default     = true
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

variable "registry_username" {
  default     = null
  type        = string
  description = "(Not needed if is_legacy_deployment is true) The username for the docker registry from which to source the terraform_enterprise container images."
}

variable "registry_password" {
  default     = null
  type        = string
  description = "(Not needed if is_legacy_deployment is true) The password for the docker registry from which to source the terraform_enterprise container images."
}

variable "resource_group_name_dns" {
  type        = string
  default     = "ptfedev-com-dns-tls"
  description = "Name of resource group which contains desired DNS zone"
}

variable "tfe_image_tag" {
  default     = "latest"
  type        = string
  description = "(Not needed if is_legacy_deployment is true) The image version of the terraform-enterprise image (e.g. \"1234567\")"
}

variable "tfe_license_secret_id" {
  default     = null
  type        = string
  description = "The Key Vault secret id under which the Base64 encoded Terraform Enterprise license is stored."
}
