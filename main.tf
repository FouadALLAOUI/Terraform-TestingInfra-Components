resource "azurerm_resource_group" "test_rg" {
  name = var.name
  location = var.location
  tags = {
    "env" = local.env
    BusinessUnit       = local.business_unit["ASUX"]   
    Division           = local.division["Engineering"]  
    Environment        = local.environment["Prod"]      
    Criticality        = local.criticality["Mission Critical"] 
    DataClassification = local.data_classification["Aptiv Confidential Business"]
    BackupRequired     = local.backup_required["yes"] 
  }
}




