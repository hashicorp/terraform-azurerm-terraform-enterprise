# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# General
# -------

variable "location" {
  type        = string
  description = "Azure location name e.g. East US"
}

variable "friendly_name_prefix" {
  type        = string
  description = "Name prefix used for resources"
}

variable "resource_group_name" {
  type        = string
  description = "Azure resource group name into which to provision the Bastion virtual machine. Must be an exiting resource group."
}

variable "virtual_network_name" {
  type        = string
  description = "Name of the virtual network into which to provision the proxy virtual machine."
}

# Proxy
# -----

variable "proxy_public_ssh_key_secret_name" {
  type        = string
  description = "The name of the public SSH key secret for the proxy."
}

variable "proxy_user" {
  type        = string
  description = "User that have access to the proxy server"
}

variable "proxy_subnet_cidr" {
  type        = string
  description = "proxy subnet"
}

# Key Vault and Certificate
# -------------------------

variable "key_vault_id" {
  default     = null
  type        = string
  description = "The identity of the Key Vault which contains secrets and certificates."
}

variable "mitmproxy_ca_certificate_secret" {
  default     = null
  description = <<-EOD
  The identifier of a secret comprising a Base64 encoded PEM certificate file for the mitmproxy Certificate Authority.
  For Azure, the secret resides in Azure Key Vault.
  EOD
  type        = string
}

variable "mitmproxy_ca_private_key_secret" {
  default     = null
  description = <<-EOD
  The identifier of a secret comprising a Base64 encoded PEM private key file for the mitmproxy Certificate Authority.
  For Azure, the secret resides in Azure Key Vault.
  EOD
  type        = string
}

# Metrics
# -------
variable "metrics_endpoint_enabled" {
  default     = null
  type        = bool
  description = <<-EOD
  (Optional) Metrics are used to understand the behavior of Terraform Enterprise and to
  troubleshoot and tune performance. Enable an endpoint to expose container metrics.
  Defaults to false.
  EOD
}

variable "metrics_endpoint_port_http" {
  default     = null
  type        = number
  description = <<-EOD
  (Optional when metrics_endpoint_enabled is true.) Defines the TCP port on which HTTP metrics
  requests will be handled.
  Defaults to 9090.
  EOD
}

variable "metrics_endpoint_port_https" {
  default     = null
  type        = string
  description = <<-EOD
  (Optional when metrics_endpoint_enabled is true.) Defines the TCP port on which HTTPS metrics
  requests will be handled.
  Defaults to 9091.
  EOD
}

# Tagging
# -------

variable "tags" {
  default     = {}
  type        = map(string)
  description = "Map of tags for resource"
}