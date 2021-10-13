# Create a subnet for proxy
# -------------------------
resource "azurerm_subnet" "proxy" {
  name                = "${local.friendly_name_prefix}-proxy-subnet"
  resource_group_name = local.resource_group_name

  address_prefixes     = [local.network_proxy_subnet_cidr]
  virtual_network_name = module.private_active_active.network.network.name
}

# Create a security group for proxy
# ---------------------------------
resource "azurerm_network_security_group" "proxy" {
  name                = "${local.friendly_name_prefix}-proxy-nsg"
  location            = var.location
  resource_group_name = local.resource_group_name

  security_rule {
    name      = "allow-inbound"
    priority  = 100
    direction = "Inbound"
    access    = "Allow"
    protocol  = "Tcp"

    source_address_prefix = "*"
    source_port_range     = "*"

    destination_port_range     = "22"
    destination_address_prefix = local.network_proxy_subnet_cidr
  }

  tags = local.common_tags
}

# Create a network interface for the proxy virtual machine
# --------------------------------------------------------
resource "azurerm_network_interface" "proxy" {
  name                = format("%s-proxy-nic", local.friendly_name_prefix)
  location            = var.location
  resource_group_name = local.resource_group_name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.proxy.id
    private_ip_address_allocation = "dynamic"
  }

  tags = local.common_tags
}

resource "azurerm_network_interface_security_group_association" "proxy" {
  network_interface_id      = azurerm_network_interface.proxy.id
  network_security_group_id = azurerm_network_security_group.proxy.id
}

# Create the proxy virtual machine
# --------------------------------
resource "azurerm_linux_virtual_machine" "proxy" {
  name                = format("%s-proxy", local.friendly_name_prefix)
  location            = var.location
  resource_group_name = local.resource_group_name

  network_interface_ids = [azurerm_network_interface.proxy.id]
  size                  = "Standard_D1_v2"
  admin_username        = local.proxy_user

  custom_data = base64encode(local.proxy_script)

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  admin_ssh_key {
    username   = local.proxy_user
    public_key = data.azurerm_key_vault_secret.proxy_public_ssh_key.value
  }

  tags = local.common_tags
}
