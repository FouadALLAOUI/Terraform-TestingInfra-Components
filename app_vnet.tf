resource "azurerm_virtual_network" "app_vnet" {
  name                = "app_vnet"
  address_space       = ["172.27.0.0/23"]
  location            = var.location
  resource_group_name = azurerm_resource_group.test_rg.name
}


resource "azurerm_subnet" "apim_subnet" {
  name                 = "apim_subnet"
  resource_group_name  = azurerm_resource_group.test_rg.name
  virtual_network_name = azurerm_virtual_network.app_vnet.name
  address_prefixes     = ["172.26.2.0/26"]
}

resource "azurerm_subnet" "aks_subnet" {
  name                 = "aks_subnet"
  resource_group_name  = azurerm_resource_group.test_rg.name
  virtual_network_name = azurerm_virtual_network.app_vnet.name
  address_prefixes     = ["172.27.3.0/24"]
}

resource "azurerm_subnet" "private_endpoint_subnet" {
  name                 = "endpoint_subnet"
  resource_group_name  = azurerm_resource_group.test_rg.name
  virtual_network_name = azurerm_virtual_network.app_vnet.name
  address_prefixes     = ["172.27.4.0/26"]
}

resource "azurerm_virtual_network_peering" "app_to_secnet" {
  name = "apptosec"
  virtual_network_name = azurerm_virtual_network.app_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.sec_net.name
  resource_group_name = azurerm_resource_group.test_rg.name
  allow_virtual_network_access = true
  allow_forwarded_traffic = true
}












