resource "azurerm_public_ip" "external_ip" {
  name                = "${var.environment}-external-ip"
  resource_group_name = azurerm_resource_group.aks.name
  location            = azurerm_resource_group.aks.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_virtual_network" "vpc_network" {
  name                = "${var.environment}-vpc"
  address_space       = var.vpc_address_space
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  dns_servers         = var.dns_servers
}

resource "azurerm_subnet" "public_subnet" {
  name                 = "${var.environment}-public-subnet"
  resource_group_name  = azurerm_resource_group.aks.name
  virtual_network_name = azurerm_virtual_network.vpc_network.name
  address_prefixes     = var.private_subnet
}

resource "azurerm_subnet" "private_subnet" {
  name                 = "${var.environment}-private-subnet"
  resource_group_name  = azurerm_resource_group.aks.name
  virtual_network_name = azurerm_virtual_network.vpc_network.name
  address_prefixes     = var.private_subnet
}

