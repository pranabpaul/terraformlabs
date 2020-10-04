
resource "azurerm_resource_group" "core" {
  name     = "core"
  location = var.loc
  tags = var.tags
}

resource "azurerm_public_ip" "vpnGatewayPublicIp" {
  name                = "vpnGatewayPublicIp"
  resource_group_name = azurerm_resource_group.core.name
  location            = azurerm_resource_group.core.location
  allocation_method   = "Dynamic"

  tags = {
    environment = "Production"
  }
}

resource "azurerm_virtual_network" "coreVnet" {
  name                = "coreVnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.core.location
  resource_group_name = azurerm_resource_group.core.name
  dns_servers         = ["1.1.1.1", "1.0.0.1"]
}

resource "azurerm_subnet" "gatewaySubnet" {
  name                 = "gatewaySubnet"
  resource_group_name  = azurerm_resource_group.core.name
  virtual_network_name = azurerm_virtual_network.coreVnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "training" {
  name                 = "training"
  resource_group_name  = azurerm_resource_group.core.name
  virtual_network_name = azurerm_virtual_network.coreVnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "dev" {
  name                 = "dev"
  resource_group_name  = azurerm_resource_group.core.name
  virtual_network_name = azurerm_virtual_network.coreVnet.name
  address_prefixes     = ["10.0.2.0/24"]
}
/*
resource "azurerm_virtual_network_gateway" "vpnGateway" {
  name                = "test"
  location            = azurerm_resource_group.core.location
  resource_group_name = azurerm_resource_group.core.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = true
  sku           = "Basic"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.vpnGatewayPublicIp.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gatewaySubnet.id
  }
}
*/