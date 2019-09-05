resource "azurerm_virtual_machine_scale_set" "secondary" {
  count               = "${var.vm["count"] > 0 ? 1 : 0}"     # don't make the set if the count is 0
  name                = "${local.prefix}-secondary-scaleset"
  resource_group_name = "${var.rg_name}"
  location            = "${var.location}"
  upgrade_policy_mode = "Manual"

  storage_profile_image_reference {
    publisher = "${var.storage_image["publisher"]}"
    offer     = "${var.storage_image["offer"]}"
    sku       = "${var.storage_image["sku"]}"
    version   = "${var.storage_image["version"]}"
  }

  sku {
    name     = "${var.vm["size"]}"
    tier     = "${var.vm["size_tier"]}"
    capacity = "${var.vm["count"]}"
  }

  network_profile {
    name    = "${local.prefix}-secondary-network-profile"
    primary = true

    ip_configuration {
      name      = "${local.prefix}-secondary-ip-conf"
      subnet_id = "${var.subnet_id}"
      primary   = true
    }
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      key_data = "${var.ssh_public_key}"
      path     = "/home/${var.username}/.ssh/authorized_keys"
    }
  }

  os_profile {
    computer_name_prefix = "${local.prefix}-secondary-"
    admin_username       = "${var.username}"
    custom_data          = "${var.cloud_init_data}"
  }

  storage_profile_os_disk {
    create_option     = "FromImage"
    os_type           = "Linux"
    managed_disk_type = "StandardSSD_LRS"
  }

  tags = {
    "Name" = "${local.prefix}"
  }
}
