locals {
  
  env = "TEST"

  business_unit = {
    "ASUX"       = "ASUX"
    "SPS"        = "SPS"
    "Enterprise" = "Enterprise"
  }

  division = {
    "GSS"        = "GSS"
    "Engineering" = "Engineering"
    "CS"         = "CS"
    "EDS"        = "EDS"
    "ERP"        = "ERP"
    "BI"         = "BI"
    "Finance"    = "Finance"
    "HR"         = "HR"
    "Marketing"  = "Marketing"
    "SCM"        = "SCM"
  }

  environment = {
    "Prod"    = "Prod"
    "Pre-Prod" = "Pre-Prod"
    "DR"      = "DR"
    "Test"    = "Test"
    "Dev"     = "Dev"
  }

  criticality = {
    "Mission Critical" = "Mission Critical"
    "Business Critical" = "Business Critical"
    "Task Critical"   = "Task Critical"
    "Standard"        = "Standard"
  }

  data_classification = {
    "Aptiv Secret"               = "Aptiv Secret"
    "Aptiv Confidential Business" = "Aptiv Confidential Business"
    "Aptiv Confidential Personal" = "Aptiv Confidential Personal"
    "Aptiv Sensitive Business"   = "Aptiv Sensitive Business"
    "Aptiv Sensitive Personal"   = "Aptiv Sensitive Personal"
    "Aptiv Internal"             = "Aptiv Internal"
    "Aptiv Public"               = "Aptiv Public"
  }

  backup_required = {
    "yes" = "Yes"
    "no"  = "No"
  }
  
  
}
