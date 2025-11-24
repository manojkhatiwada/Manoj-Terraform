# Configure the Azure Provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "REPLACE_WITH_YOUR_SUBSCRIPTION_ID"
}

# Local variables
locals {
  resource_group_name = "manoj-web-rg"
  location            = "East US"
  prefix              = "manojweb"
  vm_size             = "Standard_B1s"
  admin_username      = "manoj_azureuser"
  admin_password      = "P@ssw0rd1234!"
}

# Create Resource Group
resource "azurerm_resource_group" "main" {
  name     = local.resource_group_name
  location = local.location
}

# Create Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = "${local.prefix}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

# Create Subnet
resource "azurerm_subnet" "main" {
  name                 = "${local.prefix}-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create Public IP
resource "azurerm_public_ip" "main" {
  name                = "${local.prefix}-public-ip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Create Network Security Group (allow HTTP only)
resource "azurerm_network_security_group" "main" {
  name                = "${local.prefix}-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create Network Interface
resource "azurerm_network_interface" "main" {
  name                = "${local.prefix}-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }
}

# Associate NSG with Network Interface
resource "azurerm_network_interface_security_group_association" "main" {
  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = azurerm_network_security_group.main.id
}

# Create Virtual Machine
resource "azurerm_linux_virtual_machine" "main" {
  name                = "${local.prefix}-vm"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = local.vm_size
  admin_username      = local.admin_username

  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]

  disable_password_authentication = false
  admin_password                  = local.admin_password

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  custom_data = base64encode(<<-EOF
    #cloud-config
    packages:
      - nginx

    write_files:
      - path: /var/www/html/index.html
        content: |
          ${file("${path.module}/manoj.html")}
        permissions: '0644'

    runcmd:
      - systemctl start nginx
      - systemctl enable nginx
  EOF
  )
}

# Output
output "public_ip_address" {
  description = "Public IP address - Open http://THIS_IP in your browser"
  value       = azurerm_public_ip.main.ip_address
}
