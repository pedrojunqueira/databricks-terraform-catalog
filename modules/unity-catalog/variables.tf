variable "access_connector_name" {
  description = "Name of the Unity Catalog access connector"
  type        = string
  default     = "unity-catalog-access-connector"
}

variable "managed_resource_group_name" {
  description = "Name of the managed resource group where the access connector is located"
  type        = string
}

variable "storage_account_id" {
  description = "ID of the storage account to assign permissions to"
  type        = string
}

variable "storage_url" {
  description = "ABFSS URL of the storage location"
  type        = string
}

variable "credential_name" {
  description = "Name for the Unity Catalog storage credential"
  type        = string
}

variable "credential_comment" {
  description = "Comment for the storage credential"
  type        = string
  default     = "Storage credential for Unity Catalog"
}

variable "external_location_name" {
  description = "Name for the Unity Catalog external location"
  type        = string
}

variable "external_location_comment" {
  description = "Comment for the external location"
  type        = string
  default     = "External location for Unity Catalog data storage"
}

variable "catalog_name" {
  description = "Name for the Unity Catalog catalog"
  type        = string
}

variable "catalog_comment" {
  description = "Comment for the catalog"
  type        = string
  default     = "Unity Catalog for data assets"
}