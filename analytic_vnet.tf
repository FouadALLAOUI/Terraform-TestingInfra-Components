resource "azurerm_virtual_network" "dataanalytics_vnet" {
  name                = "DataAnalytycs-02-vNet"
  address_space       = ["172.28.0.0/23"]
  location            = azurerm_resource_group.test_rg.location
  resource_group_name = azurerm_resource_group.test_rg.name
}

resource "azurerm_subnet" "dbx_subnet" {
  name                 = "DBx-Subnet"
  resource_group_name  = azurerm_resource_group.test_rg.name
  virtual_network_name = azurerm_virtual_network.dataanalytics_vnet.name
  address_prefixes     = ["172.28.0.0/24"]
}

resource "azurerm_subnet" "lake_subnet" {
  name                 = "PrivateEndpoint-Subnet"
  resource_group_name  = azurerm_resource_group.test_rg.name
  virtual_network_name = azurerm_virtual_network.dataanalytics_vnet.name
  address_prefixes     = ["172.28.0.0/26"]
}

resource "azurerm_virtual_network_peering" "analyticsnet_to_secnet" {
  name = "fanalyticstosec"
  virtual_network_name = azurerm_virtual_network.dataanalytics_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.sec_net.name
  resource_group_name = azurerm_resource_group.test_rg.name
  allow_virtual_network_access = true
  allow_forwarded_traffic = true
}








