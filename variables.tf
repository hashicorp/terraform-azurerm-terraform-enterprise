# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# General
# -------
variable "is_replicated_deployment" {
  type        = bool
  description = "TFE will be installed using a Replicated license and deployment method."
  default     = true
}

variable "friendly_name_prefix" {
  type        = string
  description = "(Required) Name prefix used for resources"
}

variable "container_runtime_engine" {
  default     = "docker"
  type        = string
  description = "The container runtime engine to run the FDO container on. Default is docker."
  validation {
    condition     = contains(["docker", "podman"], var.container_runtime_engine)
    error_message = "Supported values for container_runtime_enginer are docker and podman."
  }
}

variable "distribution" {
  type        = string
  description = "(Required) What is the OS distribution of the instance on which Terraoform Enterprise will be deployed?"
  validation {
    condition     = contains(["rhel", "ubuntu"], var.distribution)
    error_message = "Supported values for distribution are 'rhel' or 'ubuntu'."
  }
}

variable "domain_name" {
  default     = null
  type        = string
  description = "(Required) Domain to create Terraform Enterprise subdomain within"
}

variable "tfe_subdomain" {
  default     = null
  type        = string
  description = "Subdomain for TFE"
}

variable "tfe_image" {
  default     = "images.releases.hashicorp.com/hashicorp/terraform-enterprise:v202311-1"
  type        = string
  description = "(Not needed if is_replicated_deployment is true) The registry path, image name, and image version"
}

# DNS
# ---
variable "dns_create_record" {
  default     = true
  type        = bool
  description = "If true, will create a DNS record. If false, no record will be created and IP of load balancer will instead be output."
}

variable "dns_external_fqdn" {
  default     = null
  type        = string
  description = "External DNS FQDN should be supplied if dns_create_record is false"
}

# External Vault
# --------------
variable "extern_vault_addr" {
  default     = null
  type        = string
  description = "(Required if var.extern_vault_enable = true) URL of external Vault cluster."
}

variable "extern_vault_namespace" {
  default     = null
  type        = string
  description = "(Optional if var.extern_vault_enable = true) The Vault namespace"
}

variable "extern_vault_path" {
  default     = "auth/approle"
  type        = string
  description = "(Optional if var.extern_vault_enable = true) Path on the Vault server for the AppRole auth. Defaults to auth/approle."
}

variable "extern_vault_role_id" {
  default     = null
  type        = string
  description = "(Required if var.extern_vault_enable = true) AppRole RoleId to use to authenticate with the Vault cluster."
}

variable "extern_vault_secret_id" {
  default     = null
  type        = string
  description = "(Required if var.extern_vault_enable = true) AppRole SecretId to use to authenticate with the Vault cluster."
}

variable "extern_vault_token_renew" {
  default     = 3600
  type        = number
  description = "(Optional if var.extern_vault_enable = true) How often (in seconds) to renew the Vault token. Defaults to 3600."
}

# Provider
# --------
variable "location" {
  default     = "East US"
  type        = string
  description = "(Required) Azure location name e.g. East US"
}

variable "zones" {
  default     = ["1", "2", "3"]
  type        = list(string)
  description = "Azure zones to use for applicable resources"
}

variable "resource_group_name" {
  default     = null
  type        = string
  description = "(Required) Azure resource group name"
}

variable "resource_group_name_dns" {
  default     = null
  type        = string
  description = "Name of resource group which contains desired DNS zone"
}

# Bastion
# -------
variable "create_bastion" {
  default     = true
  type        = bool
  description = "If true, will create Azure Bastion PaaS and required resources https://azure.microsoft.com/en-us/services/azure-bastion/"
}

# Network
# -------
variable "enable_ssh" {
  default     = false
  type        = bool
  description = "Enable SSH access on port 22 to the VM instance (standalone, load_balancer deployments only, not App GW). This is ***NOT RECOMMENDED*** for production deployments."
}

variable "network_private_ip" {
  default     = null
  type        = string
  description = "(optional) Private IP address to use for LB/AG endpoint"
}

variable "network_private_subnet_id" {
  default     = null
  type        = string
  description = "(Optional) Existing network private subnet ID"
}

variable "network_frontend_subnet_id" {
  default     = null
  type        = string
  description = "(Optional) Existing network frontend subnet ID"
}

variable "network_bastion_subnet_id" {
  default     = null
  type        = string
  description = "(Optional) Existing network Bastion subnet ID"
}

variable "network_redis_subnet_id" {
  default     = null
  type        = string
  description = "(Optional) Existing network Redis subnet ID"
}

variable "network_database_subnet_id" {
  default     = null
  type        = string
  description = "The identity of an existing database subnetwork."
}

variable "network_database_private_dns_zone_id" {
  default     = null
  type        = string
  description = "The identity of an existing private DNS zone for the database."
}

variable "network_cidr" {
  default     = "10.0.0.0/16"
  type        = string
  description = "(Optional) CIDR range for network"
}

variable "network_private_subnet_cidr" {
  default     = "10.0.32.0/20"
  type        = string
  description = "(Optional) Subnet CIDR range for TFE"
}

variable "network_frontend_subnet_cidr" {
  default     = "10.0.0.0/20"
  type        = string
  description = "(Optional) Subnet CIDR range for frontend"
}

variable "network_bastion_subnet_cidr" {
  default     = "10.0.16.0/20"
  type        = string
  description = "(Optional) Subnet CIDR range for Bastion"
}

variable "network_redis_subnet_cidr" {
  default     = "10.0.48.0/20"
  type        = string
  description = "(Optional) Subnet CIDR range for Redis"
}

variable "network_database_subnet_cidr" {
  default     = "10.0.64.0/20"
  type        = string
  description = "The CIDR range of the database subnetwork."
}

variable "network_allow_range" {
  default     = "*"
  type        = string
  description = "(Optional) Network range to allow access to TFE"
}

# TFE License
# -----------
variable "hc_license" {
  default     = null
  type        = string
  description = "(Not needed if is_replicated_deployment is true) The raw TFE license that is validated on application startup."
}

variable "license_reporting_opt_out" {
  default     = false
  type        = bool
  description = "(Not needed if is_replicated_deployment is true) Whether to opt out of reporting licensing information to HashiCorp. Defaults to false."
}

variable "tfe_license_secret_id" {
  default     = null
  type        = string
  description = "The Key Vault secret ID under which the Base64 encoded TFE license is stored."
}

# Air-gapped Installations ONLY
# -----------------------------
variable "tfe_license_bootstrap_airgap_package_path" {
  default     = null
  type        = string
  description = "(Required if air-gapped installation) The URL of a Replicated airgap package for Terraform Enterprise. The suggested path is '/var/lib/ptfe/ptfe.airgap'."
}

variable "airgap_url" {
  default     = null
  type        = string
  description = "(Optional) The URL of a Replicated airgap package for Terraform Enterprise. NOTE: The airgap_url package is expected to be on the tfe_license_bootstrap_airgap_package_path already in true airgapped deployments. This variable is used in dev and test scenarios when the user wants to also install the prerequisistes for an airgapped deployment."
}

# Object Storage
# --------------
variable "storage_account_name" {
  default     = null
  type        = string
  description = "Storage account name"
}

variable "storage_account_key" {
  default     = null
  type        = string
  description = "Storage account key"
}

variable "storage_account_container_name" {
  default     = null
  type        = string
  description = "Storage account container name"
}

variable "storage_account_primary_blob_connection_string" {
  default     = null
  type        = string
  description = "Storage account primary blob endpoint"
}

# Service Accounts
# ----------------
variable "storage_account_tier" {
  default     = "Standard"
  type        = string
  description = "Storage account tier Standard or Premium"
}

variable "storage_account_replication_type" {
  default     = "GRS"
  type        = string
  description = "Storage account type LRS, GRS, RAGRS, ZRS. NOTE: This is defaulted to 'GRS' because of a known intermittent error sited here: https://github.com/hashicorp/terraform-provider-azurerm/issues/5299"

  validation {
    condition = (
      var.storage_account_replication_type == "LRS" ||
      var.storage_account_replication_type == "GRS" ||
      var.storage_account_replication_type == "RAGRS" ||
      var.storage_account_replication_type == "ZRS" ||
      var.storage_account_replication_type == null
    )

    error_message = "Supported values for storage_account_replication_type are 'LRS', 'GRS', 'RAGRS', and 'ZRS'."
  }
}

# Database
# --------
variable "database_user" {
  default     = "tfeuser"
  type        = string
  description = "Postgres username"
}

variable "database_extensions" {
  default = [
    "CITEXT",
    "HSTORE",
    "UUID-OSSP",
  ]
  type        = list(string)
  description = "A list of PostgreSQL extensions to enable."
}

variable "database_machine_type" {
  default     = "GP_Standard_D4s_v3"
  type        = string
  description = "Postgres sku short name: tier + family + cores"
}

variable "database_size_mb" {
  default     = 32768
  type        = number
  description = "Postgres storage size in MB"
}

variable "database_version" {
  default     = 12
  type        = number
  description = "Postgres version"
}

variable "database_backup_retention_days" {
  default     = 7
  type        = number
  description = "Backup retention days for the PostgreSQL server."

  validation {
    condition = (
      var.database_backup_retention_days >= 7 &&
      var.database_backup_retention_days <= 35
    )

    error_message = "Supported values for database_backup_retention_days are between 7 and 35 days."
  }
}

variable "database_availability_zone" {
  default     = 1
  type        = number
  description = "The Availability Zone of the PostgreSQL Flexible Server."

  validation {
    condition = (
      var.database_availability_zone == 1 ||
      var.database_availability_zone == 2 ||
      var.database_availability_zone == 3
    )

    error_message = "Possible values for database_availability_zone are 1, 2 and 3."
  }
}

variable "pg_extra_params" {
  default     = null
  type        = string
  description = "Parameter keywords of the form param1=value1&param2=value2 to support additional options that may be necessary for your specific PostgreSQL server. Allowed values are documented on the PostgreSQL site. An additional restriction on the sslmode parameter is that only the require, verify-full, verify-ca, and disable values are allowed."
}

# Load Balancer
# -------------
variable "load_balancer_type" {
  default     = "application_gateway"
  type        = string
  description = "Expected value of 'application_gateway' or 'load_balancer'"

  validation {
    condition = (
      var.load_balancer_type == "application_gateway" ||
      var.load_balancer_type == "load_balancer"
    )

    error_message = "The load_balancer_type value must be 'application_gateway' or 'load_balancer'."
  }
}

variable "load_balancer_enable_http2" {
  default     = true
  type        = bool
  description = "Determine if HTTP2 enabled on Application Gateway"
}

variable "load_balancer_public" {
  default     = true
  type        = bool
  description = "Load balancer will use public IP if true"
}

variable "load_balancer_request_routing_rule_minimum_priority" {
  default     = 1000
  type        = number
  description = "The minimum priority for request routing rule. Lower priotity numbered rules take precedence over higher priotity number rules."
  validation {
    condition = (
      var.load_balancer_request_routing_rule_minimum_priority > 1 &&
      var.load_balancer_request_routing_rule_minimum_priority < 19000
    )
    error_message = "Request routing rules priority must be between 1 and 19,000."
  }
}

variable "load_balancer_sku_capacity" {
  default     = 2
  type        = number
  description = "The Capacity of the SKU to use for Application Gateway (1 to 125)"
}

variable "load_balancer_sku_name" {
  default     = "Standard_v2"
  type        = string
  description = "The Name of the SKU to use for Application Gateway, Standard_v2 or WAF_v2 accepted"

  validation {
    condition = (
      var.load_balancer_sku_name == "Standard_v2" ||
      var.load_balancer_sku_name == "WAF_v2"
    )

    error_message = "The load_balancer_sku_name value must be 'Standard_v2' or 'WAF_v2'."
  }
}

variable "load_balancer_sku_tier" {
  default     = "Standard_v2"
  type        = string
  description = "The Tier of the SKU to use for Application Gateway, Standard_v2 or WAF_v2 accepted"

  validation {
    condition = (
      var.load_balancer_sku_tier == "Standard_v2" ||
      var.load_balancer_sku_tier == "WAF_v2"
    )

    error_message = "The load_balancer_sku_tier value must be 'Standard_v2' or 'WAF_v2'."
  }
}

variable "load_balancer_waf_firewall_mode" {
  default     = "Prevention"
  type        = string
  description = "The Web Application Firewall mode (Detection or Prevention)"
}

variable "load_balancer_waf_rule_set_version" {
  default     = "3.2"
  type        = string
  description = "The Version of the Rule Set used for this Web Application Firewall. Possible values are 2.2.9, 3.0, 3.1, and 3.2."
}

variable "load_balancer_waf_file_upload_limit_mb" {
  default     = 100
  type        = number
  description = "The File Upload Limit in MB. Accepted values are in the range 1MB to 750MB for the WAF_v2 SKU, and 1MB to 500MB for all other SKUs. Defaults to 100MB."
}

variable "load_balancer_waf_max_request_body_size_kb" {
  default     = 128
  type        = number
  description = "The Maximum Request Body Size in KB. Accepted values are in the range 1KB to 128KB. Defaults to 128KB."
}

# Redis
# -----
variable "redis_family" {
  default     = "P"
  type        = string
  description = "The SKU family/pricing group to use. Valid values are C (for Basic/Standard SKU family) and P (for Premium)"
}

variable "redis_sku_name" {
  default     = "Premium"
  type        = string
  description = "The SKU of Redis to use. Possible values are Basic, Standard and Premium."
}

variable "redis_size" {
  default     = "1"
  type        = string
  description = "The size of the Redis cache to deploy. Valid values for a SKU family of C (Basic/Standard) are 0, 1, 2, 3, 4, 5, 6, and for P (Premium) family are 1, 2, 3, 4."
}

variable "redis_use_password_auth" {
  default     = true
  type        = bool
  description = "If set to false, the Redis instance will be accessible without authentication. enable_authentication can only be set to false if a subnet_id is specified; and only works if there aren't existing instances within the subnet with enable_authentication set to true."
}

variable "redis_rdb_backup_enabled" {
  default     = false
  type        = bool
  description = "Is Backup Enabled? Only supported on Premium SKU's. If rdb_backup_enabled is true and redis_rdb_storage_connection_string is null, a new, Premium storage account will be created."
}

variable "redis_rdb_backup_frequency" {
  default     = null
  type        = number
  description = "The Backup Frequency in Minutes. Only supported on Premium SKU's. Possible values are: 15, 30, 60, 360, 720 and 1440."
}

variable "redis_rdb_backup_max_snapshot_count" {
  default     = null
  type        = number
  description = "The maximum number of snapshots to create as a backup. Only supported for Premium SKU's."
}

variable "redis_rdb_existing_storage_account" {
  default     = null
  type        = string
  description = "Name of an existing Premium Storage Account for data encryption at rest. If value is null, a new, Premium storage account will be created."
}

variable "redis_rdb_existing_storage_account_rg" {
  default     = null
  type        = string
  description = "Name of the resource group that contains the existing Premium Storage Account for data encryption at rest."
}

variable "redis_use_tls" {
  default     = false
  type        = bool
  description = "Boolean to determine if the Redis service requires TLS."
}

variable "redis_minimum_tls_version" {
  default     = "1.2"
  type        = string
  description = "The minimum TLS version. '1.2' is suggested."
}

# VM
# --
variable "http_port" {
  default     = 80
  type        = number
  description = "(Optional if is_replicated_deployment is false) Port application listens on for HTTP. Default is 80."
}

variable "https_port" {
  default     = 443
  type        = number
  description = "(Optional if is_replicated_deployment is false) Port application listens on for HTTPS. Default is 443."
}

variable "vm_node_count" {
  default     = 2
  type        = number
  description = "The number of instances to create for TFE environment."

  validation {
    condition     = var.vm_node_count <= 5
    error_message = "The vm_node_count value must be less than or equal to 5."
  }
}

variable "vm_user" {
  default     = "tfeuser"
  type        = string
  description = "Virtual machine user name."
}

variable "vm_public_key" {
  default     = null
  type        = string
  description = "Virtual machine public key for authentication (2048-bit ssh-rsa)."
}

variable "vm_image_id" {
  default     = "ubuntu"
  type        = string
  description = "Virtual machine image id - may be 'ubuntu' (default), 'rhel', or custom image resource id."

  validation {
    condition = (
      var.vm_image_id == "ubuntu" ||
      var.vm_image_id == "rhel" ||
      var.vm_image_id == "manual" ||
      substr(var.vm_image_id, 0, 14) == "/subscriptions"
    )

    error_message = "The vm_image_id value must be 'ubuntu', 'rhel', 'manual', or an Azure image resource ID beginning with \"/subscriptions\"."
  }
}

variable "vm_image_publisher" {
  type        = string
  description = "The image publisher of the base image to install Terraform Enterprise on.  This is used in conjunction with vm_image_offer, vm_image_sku, and vm_image_version to determine the image to install from the public markeplace when vm_image_id is not provided."
  default     = null
}

variable "vm_image_offer" {
  type        = string
  description = "The image offer of the base image to install Terraform Enterprise on.  This is used in conjunction with vm_image_publisher, vm_image_sku, and vm_image_version to determine the image to install from the public markeplace when vm_image_id is not provided."
  default     = null
}

variable "vm_image_sku" {
  type        = string
  description = "The image sku of the base image to install Terraform Enterprise on.  This is used in conjunction with vm_image_publisher, vm_image_offer, and vm_image_version to determine the image to install from the public markeplace when vm_image_id is not provided."
  default     = null
}

variable "vm_image_version" {
  type        = string
  description = "The image version of the base image to install Terraform Enterprise on.  This is used in conjunction with vm_image_publisher, vm_image_offer, and vm_image_sku to determine the image to install from the public markeplace when vm_image_id is not provided."
  default     = null
}

variable "vm_sku" {
  default     = "Standard_D4_v3"
  type        = string
  description = "Azure virtual machine sku."
}

variable "vm_os_disk_disk_size_gb" {
  default     = 100
  type        = number
  description = "The size of the OS Disk which should be created."
}

variable "vm_vmss_scale_in_rule" {
  default     = "Default"
  type        = string
  description = "The scale-in rule to use for the virtual machine scale set."

  validation {
    condition = (
      var.vm_vmss_scale_in_rule == "Default" ||
      var.vm_vmss_scale_in_rule == "NewestVM" ||
      var.vm_vmss_scale_in_rule == "OldestVM"
    )

    error_message = "The vm_vmss_scale_in_policy value must be 'Default', 'NewestVM', or 'OldestVM'."
  }
}

variable "vm_vmss_scale_in_force_deletion_enabled" {
  default     = false
  type        = bool
  description = "Should the virtual machines chosen for removal be force deleted when the virtual machine scale set is being scaled-in?"
}

variable "vm_overprovision" {
  default     = false
  type        = bool
  description = "Should Azure over-provision Virtual Machines in this Scale Set?"
}

variable "vm_upgrade_mode" {
  default     = "Manual"
  type        = string
  description = "Specifies how Upgrades (e.g. changing the Image/SKU) should be performed to Virtual Machine Instances."

  validation {
    condition = (
      var.vm_upgrade_mode == "Automatic" ||
      var.vm_upgrade_mode == "Manual" ||
      var.vm_upgrade_mode == "Rolling"
    )

    error_message = "The vm_upgrade_mode value must be 'Automatic', 'Manual', or 'Rolling'."
  }
}

variable "vm_identity_type" {
  default     = "UserAssigned"
  type        = string
  description = "The type of Managed Identity which should be assigned to the Linux Virtual Machine Scale Set."

  validation {
    condition = (
      var.vm_identity_type == "SystemAssigned" ||
      var.vm_identity_type == "UserAssigned"
    )

    error_message = "The vm_identity_type value must be 'SystemAssigned' or 'UserAssigned'."
  }
}

variable "vm_os_disk_storage_account_type" {
  default     = "StandardSSD_LRS"
  type        = string
  description = "The Type of Storage Account which should back this OS Disk."
  validation {
    condition = (
      var.vm_os_disk_storage_account_type == "Standard_LRS" ||
      var.vm_os_disk_storage_account_type == "StandardSSD_LRS" ||
      var.vm_os_disk_storage_account_type == "Premium_LRS" ||
      var.vm_os_disk_storage_account_type == "UltraSSD_LRS"
    )

    error_message = "The vm_os_disk_storage_account_type value must be 'Standard_LRS', 'StandardSSD_LRS', 'Premium_LRS' or 'UltraSSD_LRS'."
  }
}

variable "vm_os_disk_caching" {
  default     = "ReadWrite"
  type        = string
  description = "The type of Caching which should be used for this OS Disk."

  validation {
    condition = (
      var.vm_os_disk_caching == "None" ||
      var.vm_os_disk_caching == "ReadOnly" ||
      var.vm_os_disk_caching == "ReadWrite"
    )

    error_message = "The vm_os_disk_caching value must be 'None', 'ReadOnly', or 'ReadWrite'."
  }
}

variable "vm_zone_balance" {
  default     = true
  type        = bool
  description = "Should the Virtual Machines in this Scale Set be strictly evenly distributed across Availability Zones? Defaults to false. Changing this forces a new resource to be created."
}

# Mounted Disk Mode
# -----------------
variable "vm_data_disk_caching" {
  default     = "ReadWrite"
  type        = string
  description = "The type of Caching which should be used for this Data Disk."

  validation {
    condition = (
      var.vm_data_disk_caching == "None" ||
      var.vm_data_disk_caching == "ReadOnly" ||
      var.vm_data_disk_caching == "ReadWrite"
    )

    error_message = "The vm_data_disk_caching value must be 'None', 'ReadOnly', or 'ReadWrite'."
  }
}

variable "vm_data_disk_create_option" {
  default     = "Empty"
  type        = string
  description = "(Optional) The create option which should be used for this Data Disk. (FromImage should only be used if the source image includes data disks)."

  validation {
    condition = (
      var.vm_data_disk_create_option == "Empty" ||
      var.vm_data_disk_create_option == "FromImage"
    )

    error_message = "The vm_data_disk_create_option value must be 'None', 'ReadOnly', or 'ReadWrite'."
  }
}

variable "vm_data_disk_storage_account_type" {
  default     = "StandardSSD_LRS"
  type        = string
  description = "The Type of Storage Account which should back this Data Disk."

  validation {
    condition = (
      var.vm_data_disk_storage_account_type == "Standard_LRS" ||
      var.vm_data_disk_storage_account_type == "StandardSSD_LRS" ||
      var.vm_data_disk_storage_account_type == "Premium_LRS" ||
      var.vm_data_disk_storage_account_type == "UltraSSD_LRS"
    )

    error_message = "The vm_data_disk_storage_account_type value must be 'Standard_LRS', 'StandardSSD_LRS', 'Premium_LRS' or 'UltraSSD_LRS'."
  }
}

variable "vm_data_disk_lun" {
  default     = 0
  type        = number
  description = "The Logical Unit Number of the Data Disk, which must be unique within the Virtual Machine."
}

variable "vm_data_disk_disk_size_gb" {
  default     = 100
  type        = number
  description = "The size of the Data Disk which should be created"
}

# User Data
# ---------
variable "capacity_cpu" {
  default     = 0
  description = "Maximum number of CPU cores a Terraform run is allowed to use. Set to `0` for no limit. Defaults to `0` if no value is given."
  type        = number
}

variable "capacity_concurrency" {
  default     = 10
  description = "The maximum number of Terraform runs that will be executed concurrently on each compute instance. Defaults to `10` if no value is given."
  type        = number
}

variable "capacity_memory" {
  default     = 2048
  type        = number
  description = "The maximum amount of memory (in megabytes) that a Terraform plan or apply can use on the system; defaults to `512` for replicated mode and `2048` for FDO."
}

variable "custom_agent_image_tag" {
  default     = null
  type        = string
  description = "Configure the docker image for handling job execution within TFE. This can either be the standard image that ships with TFE or a custom image that includes extra tools not present in the default one. Should be in the format <name>:<tag>."
}

variable "custom_image_tag" {
  default     = null
  type        = string
  description = "The name and tag for your alternative Terraform build worker image in the format <name>:<tag>. Default is 'hashicorp/build-worker:now'."
}

variable "enable_monitoring" {
  default     = null
  type        = bool
  description = "Should cloud appropriate monitoring agents be installed as a part of the TFE installation script?"
}

variable "hairpin_addressing" {
  default     = null
  type        = bool
  description = "In some cloud environments, HTTP clients running on instances behind a loadbalancer cannot send requests to the public hostname of that load balancer. Use this setting to configure TFE services to redirect requests for the installation's FQDN to the instance's internal IP address. Defaults to false."
}

variable "registry" {
  default     = "images.releases.hashicorp.com"
  type        = string
  description = "(Not needed if is_replicated_deployment is true) The docker registry from which to source the terraform_enterprise container images."
}

variable "registry_password" {
  default     = null
  type        = string
  description = "(Not needed if is_replicated_deployment is true or if registry is 'images.releases.hashicorp.com') The password for the docker registry from which to source the terraform_enterprise container images."
}

variable "registry_username" {
  default     = "terraform"
  type        = string
  description = "(Not needed if is_replicated_deployment is true) The username for the docker registry from which to source the terraform_enterprise container images."
}

variable "run_pipeline_image" {
  default     = null
  type        = string
  description = "(Not needed if is_replicated_deployment is true) Container image used to execute Terraform runs. Leave blank to use the default image that comes with Terraform Enterprise. Defaults to ''."
}

variable "tfe_license_file_location" {
  default     = "/etc/terraform-enterprise.rli"
  type        = string
  description = "The path on the TFE instance to put the TFE license."
}

variable "tls_bootstrap_cert_pathname" {
  default     = null
  type        = string
  description = "The path on the TFE instance to put the certificate. ex. '/var/lib/terraform-enterprise/certificate.pem'"
}

variable "tls_bootstrap_key_pathname" {
  default     = null
  type        = string
  description = "The path on the TFE instance to put the key. ex. '/var/lib/terraform-enterprise/key.pem'"
}

variable "tls_ciphers" {
  default     = null
  type        = string
  description = "(Not needed if is_replicated_deployment is true) TLS ciphers to use for TLS. Must be valid OpenSSL format. Leave blank to use the default ciphers. Defaults to ''"
}

variable "tls_version" {
  default     = null
  type        = string
  description = "(Not needed if is_replicated_deployment is true) TLS version to use. Leave blank to use both TLS v1.2 and TLS v1.3. Defaults to '' if no value is given."
  validation {
    condition = (
      var.tls_version == null ||
      var.tls_version == "tls_1_2" ||
      var.tls_version == "tls_1_3"
    )
    error_message = "The tls_version value must be 'tls_1_2', 'tls_1_3', or null."
  }
}

variable "operational_mode" {
  default     = null
  type        = string
  description = "Where Terraform Enterprise application data will be stored. Valid values are `external`, `disk`, `active-active` or `null`. Choose `external` when storing application data in an external object storage service and database. Choose `disk` when storing application data in a directory on the Terraform Enterprise instance itself. Chose `active-active` when deploying more than 1 node. Leave it `null` when you want Terraform Enterprise to use its own default."

  validation {
    condition = contains(["external", "disk", "active-active", null], var.operational_mode)

    error_message = "The production_type must be 'external', 'disk', `active-active` or omitted."
  }
}

variable "disk_path" {
  default     = null
  type        = string
  description = "Absolute path to a directory on the instance to store Terraform Enteprise data. Valid for mounted disk installations."
}

variable "release_sequence" {
  default     = null
  type        = number
  description = "Terraform Enterprise release sequence"
}

variable "iact_subnet_list" {
  default     = []
  description = "A list of IP address ranges which will be authorized to access the IACT. The ranges must be expressed in CIDR notation."
  type        = list(string)
}

variable "iact_subnet_time_limit" {
  default     = 60
  description = "The time limit for IP addresses from iact_subnet_list to access the IACT. The value must be expressed in minutes."
  type        = number
}

variable "metrics_endpoint_enabled" {
  default     = false
  type        = bool
  description = "(Optional) Metrics are used to understand the behavior of Terraform Enterprise and to troubleshoot and tune performance. Enable an endpoint to expose container metrics. Defaults to false."
}

variable "metrics_endpoint_port_http" {
  default     = null
  type        = number
  description = "(Optional when metrics_endpoint_enabled is true.) Defines the TCP port on which HTTP metrics requests will be handled. Defaults to 9090."
}

variable "metrics_endpoint_port_https" {
  default     = null
  type        = string
  description = "(Optional when metrics_endpoint_enabled is true.) Defines the TCP port on which HTTPS metrics requests will be handled. Defaults to 9091."
}

variable "trusted_proxies" {
  default     = []
  description = "A list of IP address ranges which will be considered safe to ignore when evaluating the IP addresses of requests like those made to the IACT endpoint."
  type        = list(string)
}

variable "bypass_preflight_checks" {
  default     = false
  type        = bool
  description = "Allow the TFE application to start without preflight checks."
}

# TLS Certificates
# ----------------
variable "ca_certificate_secret" {
  default = null
  type = object({
    id           = string
    key_vault_id = string
    name         = string
    value        = string
  })
  description = "A Key Vault secret which contains the Base64 encoded version of a PEM encoded public certificate of a certificate authority (CA) to be trusted by the Virtual Machine Scale Set and the Application Gateway. This argument is only required if TLS certificates in the deployment are not issued by a well-known CA."
}

variable "load_balancer_certificate" {
  default = null
  type = object({
    key_vault_id = string
    name         = string
    secret_id    = string
  })
  description = "A Key Vault Certificate to be attached to the Application Gateway."
}

variable "vm_certificate_secret" {
  default = null
  type = object({
    key_vault_id = string
    id           = string
  })
  description = "A Key Vault secret which contains the Base64 encoded version of a PEM encoded public certificate for the Virtual Machine Scale Set."
}

variable "vm_key_secret" {
  default = null
  type = object({
    key_vault_id = string
    id           = string
  })
  description = "A Key Vault secret which contains the Base64 encoded version of a PEM encoded private key for the Virtual Machine Scale Set."
}

# Proxy
# -----
variable "no_proxy" {
  type        = list(string)
  description = "(Optional) List of IP addresses to not proxy"
  default     = []
}

variable "proxy_ip" {
  default     = null
  type        = string
  description = "IP Address of the proxy server."
}

variable "proxy_port" {
  default     = null
  type        = string
  description = "Port that the proxy server will use."
}

# Tagging
# -------
variable "tags" {
  default     = {}
  type        = map(string)
  description = "Map of tags for resource."
}
