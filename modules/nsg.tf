# Create Network Security Group
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.environment}-${var.name_prefix}-nsg"
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name

  tags = {
    environment = var.environment
  }
}

resource "azurerm_network_security_rule" "allow_http_inbound" {
  name                        = "${var.environment}-AllowHTTPInbound"
  priority                    = 220
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["80", "443", "9090", "9093"]
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.aks.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_network_security_rule" "allow_sql_server_traffic" {
  name                        = "${var.environment}-AllowSQLServerTraffic"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["1433"]
  source_address_prefix       = "*"
  destination_address_prefix  = var.destination_address_prefix
  resource_group_name         = azurerm_resource_group.aks.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_network_security_rule" "allow_sql_outbound" {
  name                        = "${var.environment}-allow_sql_outbound"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "1433"
  source_address_prefix       = "*" # Your AKS subnet CIDR block
  destination_address_prefix  = var.destination_address_prefix
  resource_group_name         = azurerm_resource_group.aks.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_network_security_rule" "allow_internet" {
  name                        = "${var.environment}-AllowInternetOutbound"
  priority                    = 200
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "Internet"
  resource_group_name         = azurerm_resource_group.aks.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

# Associate NSG with private subnet only (for SQL)
# Public subnet has NO NSG - full internet access
resource "azurerm_subnet_network_security_group_association" "nsg_association" {
  subnet_id                 = azurerm_subnet.private_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
