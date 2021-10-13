# Bastion Networking
# ------------------
resource "azurerm_subnet" "vm_bastion" {
  name                = "${local.friendly_name_prefix}-vm-bastion-subnet"
  resource_group_name = local.resource_group_name

  address_prefixes     = ["10.0.16.0/20"]
  virtual_network_name = module.private_active_active.network.network.name
}

resource "azurerm_public_ip" "vm_bastion" {
  name                = format("%s-vm-bastion", local.friendly_name_prefix)
  location            = var.location
  resource_group_name = local.resource_group_name

  allocation_method = "Dynamic"
  domain_name_label = "${local.friendly_name_prefix}-bastion"
  tags              = local.common_tags
}

resource "azurerm_network_interface" "vm_bastion" {
  name                = format("%s-vm-bastion-nic", local.friendly_name_prefix)
  location            = var.location
  resource_group_name = local.resource_group_name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.vm_bastion.id
    public_ip_address_id          = azurerm_public_ip.vm_bastion.id
    private_ip_address_allocation = "dynamic"
  }

  tags = local.common_tags
}

resource "azurerm_network_security_group" "vm_bastion_nsg" {
  name                = "${local.friendly_name_prefix}-vm-bastion-nsg"
  location            = var.location
  resource_group_name = local.resource_group_name

  # Allow inbound SSH traffic to bastion
  security_rule {
    name      = "allow-inbound-ssh"
    priority  = 125
    direction = "Inbound"
    access    = "Allow"
    protocol  = "Tcp"

    source_address_prefix = var.network_allow_range
    source_port_range     = "*"

    destination_port_range     = "22"
    destination_address_prefix = "10.0.16.0/20"
  }

  tags = local.common_tags
}

resource "azurerm_network_interface_security_group_association" "bastion" {
  network_interface_id      = azurerm_network_interface.vm_bastion.id
  network_security_group_id = azurerm_network_security_group.vm_bastion_nsg.id
}

# VM bastion
# ----------
resource "azurerm_linux_virtual_machine" "vm_bastion" {
  name                = format("%s-bastion-vm", local.friendly_name_prefix)
  location            = var.location
  resource_group_name = local.resource_group_name

  network_interface_ids = [azurerm_network_interface.vm_bastion.id]
  size                  = "Standard_D1_v2"
  admin_username        = "bastionuser"

  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "7.8"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  admin_ssh_key {
    username   = "bastionuser"
    public_key = data.azurerm_key_vault_secret.bastion_public_ssh_key.value
  }

  tags = local.common_tags
}
