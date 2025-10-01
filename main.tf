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