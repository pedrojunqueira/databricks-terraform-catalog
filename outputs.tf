output "databricks_workspace_id" {
  description = "ID of the Databricks workspace"
  value       = module.databricks_workspace.workspace_id
}

output "databricks_workspace_url" {
  description = "URL of the Databricks workspace"
  value       = module.databricks_workspace.workspace_url
}

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "managed_resource_group_name" {
  description = "Name of the managed resource group"
  value       = module.databricks_workspace.managed_resource_group_name
}

# Dev Storage Outputs
output "dev_storage_account_name" {
  description = "Name of the dev storage account"
  value       = module.dev_storage.storage_account_name
}

output "dev_storage_account_id" {
  description = "ID of the dev storage account"
  value       = module.dev_storage.storage_account_id
}

output "dev_storage_account_primary_dfs_endpoint" {
  description = "Primary DFS endpoint of the dev storage account"
  value       = module.dev_storage.primary_dfs_endpoint
}

output "dev_abfss_url" {
  description = "ABFSS URL for the dev storage container"
  value       = module.dev_storage.abfss_url
}

# Unity Catalog outputs will be available after Step 2 deployment
# Uncomment these after applying unity_catalog_step2.tf
#
# output "dev_unity_catalog_access_connector_id" {
#   description = "ID of the Unity Catalog access connector"
#   value       = module.dev_unity_catalog.access_connector_id
# }
#
# output "dev_unity_catalog_principal_id" {
#   description = "Principal ID of the Unity Catalog managed identity"
#   value       = module.dev_unity_catalog.access_connector_principal_id
# }
#
# output "dev_unity_catalog_credential_name" {
#   description = "Name of the dev Unity Catalog storage credential"
#   value       = module.dev_unity_catalog.storage_credential_name
# }
#
# output "dev_unity_catalog_external_location_name" {
#   description = "Name of the dev Unity Catalog external location"
#   value       = module.dev_unity_catalog.external_location_name
# }
#
# output "dev_unity_catalog_external_location_url" {
#   description = "URL of the dev Unity Catalog external location"
#   value       = module.dev_unity_catalog.external_location_url
# }
#
# output "dev_catalog_name" {
#   description = "Name of the dev catalog"
#   value       = module.dev_unity_catalog.catalog_name
# }