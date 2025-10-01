terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }
}

# Random string for unique storage account name
resource "random_string" "storage_suffix" {
  length  = 8
  special = true
  upper   = true
}

# Storage Account for Unity Catalog
resource "azurerm_storage_account" "main" {
  name                     = "${var.storage_account_prefix}${random_string.storage_suffix.result}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.replication_type
  account_kind             = "StorageV2"
  
  # Enable hierarchical namespace for Data Lake Gen2
  is_hns_enabled = true
  
  # Disable public access by default
  allow_nested_items_to_be_public = false
  
  tags = var.tags
}

# Storage Container for Unity Catalog data
resource "azurerm_storage_data_lake_gen2_filesystem" "main" {
  name               = var.container_name
  storage_account_id = azurerm_storage_account.main.id
  
  depends_on = [azurerm_storage_account.main]
}

# Create folder structure in the container
resource "azurerm_storage_data_lake_gen2_path" "folders" {
  for_each = toset(var.folders)
  
  path               = each.value
  filesystem_name    = azurerm_storage_data_lake_gen2_filesystem.main.name
  storage_account_id = azurerm_storage_account.main.id
  resource           = "directory"
  
  depends_on = [azurerm_storage_data_lake_gen2_filesystem.main]
}