output "workspace_id" {
  description = "ID of the Databricks workspace"
  value       = azurerm_databricks_workspace.main.id
}

output "workspace_url" {
  description = "URL of the Databricks workspace"
  value       = azurerm_databricks_workspace.main.workspace_url
}

output "managed_resource_group_name" {
  description = "Name of the managed resource group"
  value       = azurerm_databricks_workspace.main.managed_resource_group_name
}

output "managed_resource_group_id" {
  description = "ID of the managed resource group"
  value       = azurerm_databricks_workspace.main.managed_resource_group_id
}