output "access_connector_id" {
  description = "ID of the Unity Catalog access connector"
  value       = data.azurerm_databricks_access_connector.unity_catalog.id
}

output "access_connector_principal_id" {
  description = "Principal ID of the Unity Catalog managed identity"
  value       = data.azurerm_databricks_access_connector.unity_catalog.identity[0].principal_id
}

output "storage_credential_name" {
  description = "Name of the Unity Catalog storage credential"
  value       = databricks_storage_credential.main.name
}

output "external_location_name" {
  description = "Name of the Unity Catalog external location"
  value       = databricks_external_location.main.name
}

output "external_location_url" {
  description = "URL of the Unity Catalog external location"
  value       = databricks_external_location.main.url
}

output "catalog_name" {
  description = "Name of the Unity Catalog catalog"
  value       = databricks_catalog.main.name
}

output "catalog_id" {
  description = "ID of the Unity Catalog catalog"
  value       = databricks_catalog.main.id
}