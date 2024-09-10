variable "name" {
  type = string
  description = "the resource group"
  default = "testing_env_rg"
}

variable "location" {
  type = string
  description = "the location of the resourg=ce group"
  default = "West Europe"
}

variable "vnet_name" {
  default = "sec_network"
}

variable "dns_zone_name" {
  default = "riodan_nostrad"
}

variable "dns_zone_linking_name" {
  default = "linked_riodan_nostrad"
}

variable "sec_subnet_name" {
  default = "security_subnet_firewall"
}

variable "ddos_protestion_name" {
  default = "ddos_protection"
}

variable "ddos_protection_plan_enabled" {
  type = bool
  description = "Enable DDoS protection plan."
  default = true
}


variable "app_service_integration_subnet_name" {
  default = "app_integration_subnet"
}

variable "application_gateway_subnet_name" {
  default = "application_gateway_subnet"
}




variable "firewall_sku_tier" {
  type        = string
  description = "Firewall SKU."
  default     = "Premium" # Valid values are Standard and Premium
  validation {
    condition = contains(["Standard", "Premium"], var.firewall_sku_tier)
    error_message = "The sku must be one of the following: Standard, Premium"
  }
}





