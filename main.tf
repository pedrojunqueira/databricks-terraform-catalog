terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }
}

provider "azurerm" {
  features {}
}

# Databricks provider for Unity Catalog configuration
# This provider will connect to the workspace created above
provider "databricks" {
  alias                       = "workspace"
  host                        = module.databricks_workspace.workspace_url
  azure_workspace_resource_id = module.databricks_workspace.workspace_id
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Databricks Workspace Module
module "databricks_workspace" {
  source = "./modules/databricks-workspace"
  
  workspace_name      = var.databricks_workspace_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = var.databricks_sku
  tags                = var.tags
}

# Storage Account for Dev Catalog
module "dev_storage" {
  source = "./modules/storage-account"
  
  storage_account_prefix = "stunitycatalog"
  resource_group_name    = azurerm_resource_group.main.name
  location               = azurerm_resource_group.main.location
  account_tier           = var.storage_account_tier
  replication_type       = var.storage_replication_type
  container_name         = "data"
  folders                = ["catalogs"]
  tags                   = var.tags
}

# Unity Catalog for Dev
# 
# IMPORTANT DEPLOYMENT STEPS:
# 1. First deployment: terraform apply -target=azurerm_resource_group.main -target=module.databricks_workspace -target=module.dev_storage
# 2. Second deployment: terraform apply (to deploy Unity Catalog after workspace exists)
# 
# This ensures the Databricks workspace exists before configuring Unity Catalog
module "dev_unity_catalog" {
  source = "./modules/unity-catalog"
  
  providers = {
    databricks = databricks.workspace
  }
  
  managed_resource_group_name   = module.databricks_workspace.managed_resource_group_name
  storage_account_id           = module.dev_storage.storage_account_id
  storage_url                  = module.dev_storage.abfss_url
  credential_name              = "unity-catalog-credential"
  external_location_name       = "unity-catalog-external-location"
  catalog_name                 = "dev"
  catalog_comment              = "Development catalog for Unity Catalog"
  
  depends_on = [module.databricks_workspace, module.dev_storage]
}