variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "australiaeast"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-databricks-dataeng42"
}

variable "databricks_workspace_name" {
  description = "Name of the Databricks workspace"
  type        = string
  default     = "dataeng42-develop"
}

variable "databricks_sku" {
  description = "SKU for the Databricks workspace"
  type        = string
  default     = "premium"
}

variable "storage_account_tier" {
  description = "Performance tier of the storage account"
  type        = string
  default     = "Standard"
}

variable "storage_replication_type" {
  description = "Replication type for the storage account"
  type        = string
  default     = "LRS"
}

variable "unity_catalog_credential_name" {
  description = "Name for the Unity Catalog storage credential"
  type        = string
  default     = "unity-catalog-credential"
}

variable "unity_catalog_external_location_name" {
  description = "Name for the Unity Catalog external location"
  type        = string
  default     = "unity-catalog-external-location"
}

variable "dev_catalog_name" {
  description = "Name for the dev catalog"
  type        = string
  default     = "dev"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    Environment = "develop"
    Project     = "dataeng42"
    ManagedBy   = "terraform"
  }
}