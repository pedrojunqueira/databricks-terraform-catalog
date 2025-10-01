variable "storage_account_prefix" {
  description = "Prefix for the storage account name"
  type        = string
  default     = "st"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "account_tier" {
  description = "Performance tier of the storage account"
  type        = string
  default     = "Standard"
}

variable "replication_type" {
  description = "Replication type for the storage account"
  type        = string
  default     = "LRS"
}

variable "container_name" {
  description = "Name of the storage container"
  type        = string
  default     = "data"
}

variable "folders" {
  description = "List of folders to create in the container"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}