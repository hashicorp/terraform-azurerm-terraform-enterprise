provider "azurerm" {
  features {}
}

resource "random_string" "friendly_name" {
  length  = 4
  upper   = false
  number  = false
  special = false
}

resource "azurerm_resource_group" "main" {
  name     = "${local.friendly_name_prefix}-rg"
  location = "East US"

  tags = var.tags
}

# Create a virtual network for proxy
# ----------------------------------
module "network" {
  source = "../../../modules/network"

  friendly_name_prefix = local.friendly_name_prefix
  location             = local.location
  resource_group_name  = local.resource_group_name

  network_cidr                 = "10.0.0.0/16"
  network_frontend_subnet_cidr = "10.0.0.0/20"
  network_bastion_subnet_cidr  = "10.0.16.0/20"
  network_private_subnet_cidr  = "10.0.32.0/20"
  network_redis_subnet_cidr    = "10.0.48.0/20"

  load_balancer_type   = "load_balancer"
  load_balancer_public = false

  tags           = var.tags
  create_bastion = false
}

# SSH keys & Certs
# ----------------
data "azurerm_key_vault" "kv" {
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name_kv
}

data "azurerm_key_vault_secret" "proxy_public_key" {
  name         = "private-tcp-active-active-proxy-public-key"
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_key_vault_secret" "bastion_public_key" {
  name         = "private-tcp-active-active-bastion-public-key"
  key_vault_id = data.azurerm_key_vault.kv.id
}

# Create a subnet for proxy
# -------------------------
resource "azurerm_subnet" "proxy" {
  name                = "${local.friendly_name_prefix}-proxy-subnet"
  resource_group_name = local.resource_group_name

  address_prefixes     = ["10.0.64.0/20"]
  virtual_network_name = "${local.friendly_name_prefix}-network"

  depends_on = [module.network]
}

# Create a security group for proxy
# ---------------------------------
resource "azurerm_network_security_group" "proxy" {
  name                = "${local.friendly_name_prefix}-proxy-nsg"
  location            = local.location
  resource_group_name = local.resource_group_name

  security_rule {
    name      = "allow-inbound"
    priority  = 100
    direction = "Inbound"
    access    = "Allow"
    protocol  = "Tcp"

    source_address_prefix = "*"
    source_port_range     = "*"

    destination_port_range     = "*"
    destination_address_prefix = "10.0.64.0/20"
  }

  tags = var.tags
}

# Associate proxy subnet with nsg
# -------------------------------
resource "azurerm_subnet_network_security_group_association" "proxy_subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.proxy.id
  network_security_group_id = azurerm_network_security_group.proxy.id
}

# Create a network interface for the proxy virtual machine
# --------------------------------------------------------
resource "azurerm_network_interface" "proxy" {
  name                = format("%s-proxy-nic", local.friendly_name_prefix)
  location            = local.location
  resource_group_name = local.resource_group_name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.proxy.id
    private_ip_address_allocation = "dynamic"
  }

  tags = var.tags
}

resource "azurerm_network_interface_security_group_association" "proxy" {
  network_interface_id      = azurerm_network_interface.proxy.id
  network_security_group_id = azurerm_network_security_group.proxy.id
}

# Managed Service Identity
# ------------------------
resource "azurerm_user_assigned_identity" "proxy" {
  name                = "${var.friendly_name_prefix}-proxy-msi"
  location            = local.location
  resource_group_name = local.resource_group_name

  tags = var.tags
}

# Key Vault Policy - allow 'get' permission for proxy's managed identity
# ----------------
resource "azurerm_key_vault_access_policy" "tfe_kv_acl" {
  key_vault_id = data.azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.proxy.principal_id

  certificate_permissions = [
    "get",
    "list"
  ]

  secret_permissions = [
    "get",
    "list"
  ]
}

# Create the proxy virtual machine
# --------------------------------
resource "azurerm_linux_virtual_machine" "proxy" {
  name                = format("%s-proxy", local.friendly_name_prefix)
  location            = local.location
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
    public_key = data.azurerm_key_vault_secret.proxy_public_key.value
  }

  identity {
    type = "UserAssigned"

    identity_ids = [azurerm_user_assigned_identity.proxy.id]
  }

  tags = var.tags
}
