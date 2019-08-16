resource "azurerm_virtual_machine" "primary" {
  count                        = "${var.vm["count"]}"
  name                         = "${local.prefix}-${count.index}"
  resource_group_name          = "${var.rg_name}"
  location                     = "${var.location}"
  vm_size                      = "${var.vm["size"]}"
  primary_network_interface_id = "${azurerm_network_interface.primary.*.id[count.index]}"

  network_interface_ids         = ["${azurerm_network_interface.primary.*.id[count.index]}"]
  delete_os_disk_on_termination = true

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      key_data = "${var.ssh["public_key"]}"
      path     = "/home/${var.username}/.ssh/authorized_keys"
    }
  }

  os_profile {
    computer_name  = "${local.prefix}-${count.index}"
    admin_username = "${var.username}"
    custom_data    = "${element(var.cloud_init_data_list, count.index)}"
  }

  os_profile_secrets {
    source_vault_id = "${var.key_vault["id"]}"

    vault_certificates {
      certificate_url = "${var.key_vault["cert_uri"]}"
    }
  }

  storage_os_disk {
    name          = "${local.prefix}-${count.index}"
    disk_size_gb  = "${var.os_disk_size}"
    os_type       = "Linux"
    create_option = "FromImage"
    caching       = "ReadWrite"
  }

  storage_image_reference {
    publisher = "${var.storage_image["publisher"]}"
    offer     = "${var.storage_image["offer"]}"
    sku       = "${var.storage_image["sku"]}"
    version   = "${var.storage_image["version"]}"
  }
}
