# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

resource "azurerm_user_assigned_identity" "vmss" {
  location            = var.location
  name                = "${var.friendly_name_prefix}-vmss"
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_key_vault_access_policy" "tfe_vmss_kv_access" {
  for_each = toset([
    for secret in [
      var.ca_certificate_secret,
      var.certificate_secret,
      var.key_secret
    ] : secret.key_vault_id if secret != null
  ])

  key_vault_id = each.value
  object_id    = azurerm_user_assigned_identity.vmss.principal_id
  tenant_id    = var.tenant_id

  secret_permissions = [
    "Get",
    "List"
  ]
}

resource "azurerm_linux_virtual_machine_scale_set" "tfe_vmss" {
  name                = "${var.friendly_name_prefix}-vmss"
  location            = var.location
  resource_group_name = var.resource_group_name

  overprovision  = var.vm_overprovision
  instances      = var.vm_node_count
  sku            = var.vm_sku
  admin_username = var.vm_user

  upgrade_mode = var.vm_upgrade_mode

  zone_balance = var.vm_zone_balance
  zones        = var.zones

  custom_data = var.vm_userdata_script

  identity {
    type = var.vm_identity_type

    identity_ids = [azurerm_user_assigned_identity.vmss.id]
  }

  # Source image id will be used if vm_image_id anything other than 'ubuntu' or 'rhel'
  source_image_id = var.vm_image_id == "ubuntu" || var.vm_image_id == "rhel" || var.vm_image_id == "manual" ? null : var.vm_image_id

  scale_in {
    rule                   = var.vm_vmss_scale_in_rule
    force_deletion_enabled = var.vm_vmss_scale_in_force_deletion_enabled
  }

  # Source image reference will be used if vm_image_id is 'ubuntu' or 'rhel'
  dynamic "source_image_reference" {
    for_each = var.vm_image_id == "ubuntu" || var.vm_image_id == "rhel" ? [1] : []

    content {
      publisher = var.vm_image_id == "ubuntu" ? "Canonical" : "RedHat"
      offer     = var.vm_image_id == "ubuntu" ? "ubuntu-24_04-lts" : "RHEL"
      sku       = var.vm_image_id == "ubuntu" ? "server" : "8_7"
      version   = var.vm_image_id == "ubuntu" ? "latest" : "8.7.2023022801"
    }
  }

  dynamic "source_image_reference" {
    for_each = var.vm_image_id == "manual" ? [1] : []

    content {
      publisher = var.vm_image_publisher
      offer     = var.vm_image_offer
      sku       = var.vm_image_sku
      version   = var.vm_image_version
    }
  }

  admin_ssh_key {
    username   = var.vm_user
    public_key = var.vm_public_key
  }

  os_disk {
    caching              = var.vm_os_disk_caching
    storage_account_type = var.vm_os_disk_storage_account_type
    disk_size_gb         = var.vm_os_disk_disk_size_gb
  }

  dynamic "data_disk" {
    for_each = var.disk_mode ? [1] : [0]

    content {
      caching              = var.vm_data_disk_caching
      create_option        = var.vm_data_disk_create_option
      disk_size_gb         = var.vm_data_disk_disk_size_gb
      lun                  = var.vm_data_disk_lun
      storage_account_type = var.vm_data_disk_storage_account_type
    }
  }

  network_interface {
    name    = "${var.friendly_name_prefix}-nic"
    primary = true

    ip_configuration {
      name      = "${var.friendly_name_prefix}-ip"
      primary   = true
      subnet_id = var.vm_subnet_id

      load_balancer_backend_address_pool_ids       = var.load_balancer_type == "load_balancer" ? [var.load_balancer_backend_id] : null
      application_gateway_backend_address_pool_ids = var.load_balancer_type == "application_gateway" ? [var.load_balancer_backend_id] : null

      dynamic "public_ip_address" {
        for_each = var.load_balancer_public == false ? [1] : []
        content {
          name = "${var.friendly_name_prefix}-public-ip"
        }
      }
    }
  }

  tags = var.tags
}

resource "azurerm_virtual_machine_scale_set_extension" "main" {
  name                         = "${var.friendly_name_prefix}-vmss-ext"
  virtual_machine_scale_set_id = azurerm_linux_virtual_machine_scale_set.tfe_vmss.id
  publisher                    = "Microsoft.ManagedServices"
  type                         = "ApplicationHealthLinux"
  auto_upgrade_minor_version   = true
  type_handler_version         = "1.0"
  settings = jsonencode({
    "protocol" : "http",
    "port" : 80,
    "requestPath" : "/_health_check"
  })
}

data "azurerm_virtual_machine_scale_set" "tfe_vmss" {
  name                = azurerm_linux_virtual_machine_scale_set.tfe_vmss.name
  resource_group_name = var.resource_group_name
}
