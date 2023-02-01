# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

data "azurerm_client_config" "current" {}

# Create a subnet for proxy
# -------------------------
resource "azurerm_subnet" "proxy" {
  name                = "${var.friendly_name_prefix}-proxy-subnet"
  resource_group_name = var.resource_group_name

  address_prefixes     = [var.proxy_subnet_cidr]
  virtual_network_name = var.virtual_network_name
}

# Create a security group for proxy
# ---------------------------------
resource "azurerm_network_security_group" "proxy" {
  name                = "${var.friendly_name_prefix}-proxy-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name      = "allow-inbound"
    priority  = 100
    direction = "Inbound"
    access    = "Allow"
    protocol  = "Tcp"

    source_address_prefix = "*"
    source_port_range     = "*"

    destination_port_range     = "*"
    destination_address_prefix = var.proxy_subnet_cidr
  }

  tags = var.tags
}

# Create a network interface for the proxy virtual machine
# --------------------------------------------------------
resource "azurerm_network_interface" "proxy" {
  name                = format("%s-proxy-nic", var.friendly_name_prefix)
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.proxy.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}

resource "azurerm_network_interface_security_group_association" "proxy" {
  network_interface_id      = azurerm_network_interface.proxy.id
  network_security_group_id = azurerm_network_security_group.proxy.id
}

resource "azurerm_user_assigned_identity" "proxy" {
  location            = var.location
  name                = "${var.friendly_name_prefix}-proxy"
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_key_vault_access_policy" "proxy" {
  key_vault_id = var.key_vault_id
  object_id    = azurerm_user_assigned_identity.proxy.principal_id
  tenant_id    = data.azurerm_client_config.current.tenant_id

  secret_permissions = [
    "Get",
    "List"
  ]
}

module "test_proxy_init" {
  source = "github.com/hashicorp/terraform-random-tfe-utility//fixtures/test_proxy_init?ref=main"

  mitmproxy_ca_certificate_secret = var.mitmproxy_ca_certificate_secret
  mitmproxy_ca_private_key_secret = var.mitmproxy_ca_private_key_secret
  cloud                           = "azurerm"
}

# Create the proxy virtual machine
# --------------------------------
resource "azurerm_linux_virtual_machine" "proxy" {
  name                = format("%s-proxy", var.friendly_name_prefix)
  location            = var.location
  resource_group_name = var.resource_group_name

  network_interface_ids = [azurerm_network_interface.proxy.id]
  size                  = "Standard_D1_v2"
  admin_username        = var.proxy_user

  custom_data = base64encode(local.mitmproxy_selected ? (
    module.test_proxy_init.mitmproxy.user_data_script
  ) : module.test_proxy_init.squid.user_data_script)

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

  identity {
    type = "UserAssigned"

    identity_ids = [azurerm_user_assigned_identity.proxy.id]
  }

  admin_ssh_key {
    username   = var.proxy_user
    public_key = var.proxy_public_ssh_key_secret_name
  }

  tags = var.tags
}
