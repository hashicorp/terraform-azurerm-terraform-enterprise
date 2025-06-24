variable "client_id" {
  description = "The Client ID"
  type        = string
  sensitive   = true
}

variable "subscription_id" {
  description = "The Azure subscription ID to use."
  type        = string
  sensitive   = true
}

variable "client_secret" {
  description = "The Azure client secret to use."
  type        = string
  sensitive   = true
}

variable "tenant_id" {
  description = "The Azure tenant ID to use."
  type        = string
  sensitive   = true
}

variable "location" {
  default     = "East US"
  type        = string
  description = "(Optional) Azure location name e.g. East US"
}

/// registry

variable "tfe_image" {
  default     = "images.releases.hashicorp.com/hashicorp/terraform-enterprise:v202401-2"
  type        = string
  description = "(Optional) The registry path, image name, and image version."
}

variable "registry" {
  default     = "images.releases.hashicorp.com"
  type        = string
  description = "(Optional) The docker registry from which to source the terraform_enterprise container images."
}

variable "registry_password" {
  default     = null
  type        = string
  description = "(Optional) The password for the docker registry from which to source the terraform_enterprise container images."
}

variable "registry_username" {
  default     = null
  type        = string
  description = "(Optional) The username for the docker registry from which to source the terraform_enterprise container images."
}

variable "certificate_secret_name" {
  type        = string
  description = "The name of a Key Vault secret which contains the Base64 encoded version of a PEM encoded public certificate of a certificate authority (CA) to be trusted by the Virtual Machine Scale Set."
}

variable "load_balancer_certificate" {
  type        = string
  description = "A Key Vault Certificate to be attached to the Application Gateway."
}

variable "key_secret_name" {
  type        = string
  description = "The name of a Key Vault secret which contains the Base64 encoded version of a PEM encoded private key of a certificate authority (CA) to be trusted by the Virtual Machine Scale Set."
}

variable "key_vault_id" {
  type        = string
  description = "The identity of the Key Vault which contains secrets and certificates."
}

variable "domain_name" {
  type        = string
  description = "Domain for creating the Terraform Enterprise subdomain on."
}

variable "tfe_license" {
  type        = string
  description = "The raw TFE license that is validated on application startup."
}

variable "resource_group_name_dns" {
  type        = string
  description = "Name of resource group which contains desired DNS zone"
}