terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.0"
    }
  }
}

# Get the Unity Catalog Access Connector data
data "azurerm_databricks_access_connector" "unity_catalog" {
  name                = var.access_connector_name
  resource_group_name = var.managed_resource_group_name
}

# Assign Storage Blob Data Contributor role to Unity Catalog Access Connector
resource "azurerm_role_assignment" "unity_catalog_storage" {
  scope                = var.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_databricks_access_connector.unity_catalog.identity[0].principal_id
}

# Unity Catalog Storage Credential
resource "databricks_storage_credential" "main" {
  name = var.credential_name
  
  azure_managed_identity {
    access_connector_id = data.azurerm_databricks_access_connector.unity_catalog.id
  }
  
  comment = var.credential_comment
  
  depends_on = [azurerm_role_assignment.unity_catalog_storage]
}

# Unity Catalog External Location
resource "databricks_external_location" "main" {
  name = var.external_location_name
  url  = var.storage_url
  
  credential_name = databricks_storage_credential.main.name
  comment         = var.external_location_comment
  
  depends_on = [databricks_storage_credential.main]
}

# Unity Catalog - Catalog
resource "databricks_catalog" "main" {
  name           = var.catalog_name
  comment        = var.catalog_comment
  storage_root   = databricks_external_location.main.url
  
  depends_on = [databricks_external_location.main]
}