output "storage_account_id" {
  description = "ID of the storage account"
  value       = azurerm_storage_account.main.id
}

output "storage_account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.main.name
}

output "primary_dfs_endpoint" {
  description = "Primary DFS endpoint of the storage account"
  value       = azurerm_storage_account.main.primary_dfs_endpoint
}

output "container_name" {
  description = "Name of the storage container"
  value       = azurerm_storage_data_lake_gen2_filesystem.main.name
}

output "abfss_url" {
  description = "ABFSS URL for the storage container"
  value       = "abfss://${azurerm_storage_data_lake_gen2_filesystem.main.name}@${azurerm_storage_account.main.name}.dfs.core.windows.net/"
}