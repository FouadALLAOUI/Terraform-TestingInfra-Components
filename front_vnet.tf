resource "azurerm_virtual_network" "front_vnet" {
  name                = var.vnet_name
  address_space       = ["172.26.0.0/24"]
  location            = azurerm_resource_group.test_rg.location
  resource_group_name = azurerm_resource_group.test_rg.name
}

resource "azurerm_subnet" "app_service_integration_subnet" {
  name                 = var.app_service_integration_subnet_name
  resource_group_name  = azurerm_resource_group.test_rg.name
  virtual_network_name = azurerm_virtual_network.front_vnet.name
  address_prefixes     = ["172.26.2.0/24"]

  delegation {
    name = "app_service_integration_delegation"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_subnet" "application_gateway_subnet" {
  name                 = var.application_gateway_subnet_name
  resource_group_name  = azurerm_resource_group.test_rg.name
  virtual_network_name = azurerm_virtual_network.front_vnet.name
  address_prefixes     = ["172.26.3.0/24"]
}

resource "azurerm_virtual_network_peering" "frontnet_to_secnet" {
  name = "fronttosec"
  virtual_network_name = azurerm_virtual_network.front_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.sec_net.name
  resource_group_name = azurerm_resource_group.test_rg.name
  allow_virtual_network_access = true
  allow_forwarded_traffic = true
}







































