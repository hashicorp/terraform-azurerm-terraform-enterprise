# Create an SSH key for bastion instance
# --------------------------------------
resource "tls_private_key" "bastion_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Bastion Networking
# ------------------
resource "azurerm_subnet" "vm_bastion" {
  name                = "${local.friendly_name_prefix}-vm-bastion-subnet"
  resource_group_name = local.resource_group_name

  address_prefixes     = ["10.0.16.0/20"]
  virtual_network_name = "${local.friendly_name_prefix}-network"

  depends_on = [module.network]
}

resource "azurerm_public_ip" "vm_bastion" {
  name                = format("%s-vm-bastion", local.friendly_name_prefix)
  location            = local.location
  resource_group_name = local.resource_group_name

  allocation_method = "Dynamic"
  domain_name_label = "${local.friendly_name_prefix}-bastion"
  tags              = var.tags
}

resource "azurerm_network_interface" "vm_bastion" {
  name                = format("%s-vm-bastion-nic", local.friendly_name_prefix)
  location            = local.location
  resource_group_name = local.resource_group_name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.vm_bastion.id
    public_ip_address_id          = azurerm_public_ip.vm_bastion.id
    private_ip_address_allocation = "dynamic"
  }
  tags = var.tags
}

resource "azurerm_network_security_group" "vm_bastion_nsg" {
  name                = "${local.friendly_name_prefix}-vm-bastion-nsg"
  location            = local.location
  resource_group_name = local.resource_group_name

  # Allow inbound SSH traffic to bastion
  # default value for network_allow_range is * so it is open to world if not supplied
  security_rule {
    name      = "allow-inbound-ssh"
    priority  = 125
    direction = "Inbound"
    access    = "Allow"
    protocol  = "Tcp"

    # *********** THIS NEEDS TO CHANGE *********
    source_address_prefix = "*"
    source_port_range     = "*"

    destination_port_range     = "22"
    destination_address_prefix = "10.0.16.0/20"
  }

  tags = var.tags
}

resource "azurerm_network_interface_security_group_association" "bastion" {
  network_interface_id      = azurerm_network_interface.vm_bastion.id
  network_security_group_id = azurerm_network_security_group.vm_bastion_nsg.id
}

# VM bastion
# ----------
resource "azurerm_linux_virtual_machine" "vm_bastion" {
  name                = format("%s-bastion-vm", local.friendly_name_prefix)
  location            = local.location
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
    public_key = tls_private_key.bastion_ssh.public_key_openssh
  }

  tags = var.tags
}
