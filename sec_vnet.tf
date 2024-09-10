resource "azurerm_virtual_network" "sec_net" {
  name = var.vnet_name
  resource_group_name = azurerm_resource_group.test_rg.name
  location = azurerm_resource_group.test_rg.location
  address_space = ["10.0.0.0/24"]
    ddos_protection_plan {
    id     = azurerm_network_ddos_protection_plan.ddos_protection.id
    enable = var.ddos_protection_plan_enabled
  }
}

resource "azurerm_network_ddos_protection_plan" "ddos_protection" {
  name                = var.ddos_protestion_name
  location            = azurerm_resource_group.test_rg.location
  resource_group_name = azurerm_resource_group.test_rg.name
}

resource "azurerm_subnet" "fw_subnet" {
  name = var.sec_subnet_name
  virtual_network_name = azurerm_virtual_network.sec_net.name
  resource_group_name = azurerm_resource_group.test_rg.name
  address_prefixes = [ "10.0.1.0/27" ]
}

# --- Peering ---
resource "azurerm_virtual_network_peering" "secnet_to_frontnet" {
  name = "sectofront"
  virtual_network_name = azurerm_virtual_network.sec_net.name
  remote_virtual_network_id = azurerm_virtual_network.front_vnet.id
  resource_group_name = azurerm_resource_group.test_rg.name
  allow_virtual_network_access = true
  allow_forwarded_traffic = true
}

resource "azurerm_virtual_network_peering" "secnet_to_appnet" {
  name = "sectoapp"
  virtual_network_name = azurerm_virtual_network.sec_net.name
  remote_virtual_network_id = azurerm_virtual_network.app_vnet.id
  resource_group_name = azurerm_resource_group.test_rg.name
  allow_virtual_network_access = true
  allow_forwarded_traffic = true
  allow_gateway_transit = true
}

resource "azurerm_virtual_network_peering" "secnet_to_data" {
  name = "sectodata"
  virtual_network_name = azurerm_virtual_network.sec_net.name
  remote_virtual_network_id = azurerm_virtual_network.dataanalytics_vnet.id
  resource_group_name = azurerm_resource_group.test_rg.name
  allow_virtual_network_access = true
  allow_forwarded_traffic = true
  allow_gateway_transit = true
}

# --- Firewall ---
resource "azurerm_public_ip" "pip_azfw" {
  name                = "pip-azfw"
  location            = azurerm_resource_group.test_rg.location
  resource_group_name = azurerm_resource_group.test_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "fw" {
  name                = "azfw"
  location            = azurerm_resource_group.test_rg.location
  resource_group_name = azurerm_resource_group.test_rg.name
  sku_name            = "AZFW_VNet"
  sku_tier            = var.firewall_sku_tier
  ip_configuration {
    name                 = "azfw-ipconfig"
    subnet_id            = azurerm_subnet.fw_subnet.id
    public_ip_address_id = azurerm_public_ip.pip_azfw.id
  }
  firewall_policy_id = azurerm_firewall_policy.fw_policy.id
}

resource "azurerm_firewall_policy" "fw_policy" {
  name                = "firewall_policy"
  resource_group_name = azurerm_resource_group.test_rg.name
  location            = azurerm_resource_group.test_rg.location
  sku                 = var.firewall_sku_tier
}

resource "azurerm_firewall_policy_rule_collection_group" "fw_policy_rules" {
  name               = "example-fwpolicy-rcg"
  firewall_policy_id = azurerm_firewall_policy.fw_policy.id
  priority           = 500

  application_rule_collection {
    name     = "app_rule_collection1"
    priority = 500
    action   = "Deny"
    rule {
      name = "app_rule_collection1_rule1"
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses  = ["10.0.0.1"]
      destination_fqdns = ["*.microsoft.com"]
    }
  }

  network_rule_collection {
    name     = "network_rule_collection1"
    priority = 400
    action   = "Deny"
    rule {
      name                  = "network_rule_collection1_rule1"
      protocols             = ["TCP", "UDP"]
      source_addresses      = ["10.0.0.1"]
      destination_addresses = ["192.168.1.1", "192.168.1.2"]
      destination_ports     = ["80", "1000-2000"]
    }
  }

  nat_rule_collection {
    name     = "nat_rule_collection1"
    priority = 300
    action   = "Dnat"
    rule {
      name                = "nat_rule_collection1_rule1"
      protocols           = ["TCP", "UDP"]
      source_addresses    = ["10.0.0.1", "10.0.0.2"]
      destination_address = "192.168.1.1"
      destination_ports   = ["80"]
      translated_address  = "192.168.0.1"
      translated_port     = "8080"
    }
  }
  
}


# --- DNS ---
resource "azurerm_private_dns_zone" "example" {
  name                = var.dns_zone_name
  resource_group_name = azurerm_resource_group.test_rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "example" {
  name                  = var.dns_zone_linking_name
  resource_group_name   = azurerm_resource_group.test_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.example.name
  virtual_network_id    = azurerm_virtual_network.sec_net.id
}







