# === Required

variable "primary_count" {
  description = "The count of primary instances being created."
}

variable "license_file" {
  type        = "string"
  description = "Path to license file for the application"
}

variable cluster_endpoint {
  type        = "string"
  description = "URI to the cluster"
}

variable "cluster_api_endpoint" {
  type        = "string"
  description = "URI to the cluster api"
}

variable "cluster_hostname" {
  type        = "string"
  description = "The hostname of the TFE application. Example: tfe.company.com"
}

variable "distribution" {
  type        = "string"
  description = "Type of linux distribution to use. (ubuntu or rhel)"
}

variable "encryption_password" {
  type        = "string"
  description = "The password for data encryption in non-external services modes."
}

variable "cert_thumbprint" {
  type        = "string"
  description = "The thumbprint for the Azure Key Vault Certificate object generated from the provided PFX certificate."
}

variable "assistant_port" {
  description = "Port the assitant sidecar-like node service is running on."
}

variable "http_proxy_url" {
  type        = "string"
  description = "HTTP(S) Proxy URL"
}

variable "installer_url" {
  type        = "string"
  description = "URL to the cluster installer tool"
}

variable "import_key" {
  type        = "string"
  description = "An additional ssh pub key to import to all machines"
}

variable "iact" {
  type        = "map"
  description = "Expects keys: [subnet_list, subnet_time_limit]"
}

variable "postgresql" {
  type        = "map"
  description = "Expects keys: [user, password, address, database, extra_params]"
}

variable "azure_es" {
  type        = "map"
  description = "Expects keys: [enable, account_name, account_key, container]"
}

variable "airgap" {
  type        = "map"
  description = "Expects keys: [enable, package_url, installer_url]"
}

variable "weave_cidr" {
  type        = "string"
  description = "custom weave CIDR range"
}

variable "repl_cidr" {
  type        = "string"
  description = "custom replicated service CIDR range"
}

variable "release_sequence" {
  type        = "string"
  description = "The sequence ID for the Terraform Enterprise version to pin the cluster to."
}

# === Optional

variable "ca_bundle_url" {
  type        = "string"
  description = "URL to CA certificate file used for the internal `ptfe-proxy` used for outgoing connections"
}

# === Misc

locals {
  install_mode = "${var.azure_es["enable"] == "True" ? "es" : ""}"
  is_airgap    = "${var.airgap["enable"] == "True" ? "True" : "False"}"
}

resource "random_pet" "console_password" {
  length = 3
}

resource "random_string" "bootstrap_token_id" {
  length  = 6
  upper   = false
  special = false
}

resource "random_string" "default_enc_password" {
  length  = 32
  upper   = true
  special = false
}

resource "random_string" "setup_token" {
  length  = 32
  upper   = false
  special = false
}

resource "random_string" "bootstrap_token_suffix" {
  length  = 16
  upper   = false
  special = false
}
