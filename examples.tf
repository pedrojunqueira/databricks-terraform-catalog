# Example: Adding Additional Catalogs with Separate Storage Accounts
# 
# This file demonstrates how to extend the project to include multiple catalogs,
# each with their own dedicated storage account. This provides complete isolation
# between environments (dev, staging, prod) or teams.
#
# To use this example:
# 1. Uncomment the desired catalog sections below
# 2. Run `terraform plan` to review changes
# 3. Run `terraform apply` to create the additional resources

# Example: Production Catalog with Separate Storage
# module "prod_storage" {
#   source = "./modules/storage-account"
#   
#   storage_account_prefix = "stprodcatalog"
#   resource_group_name    = azurerm_resource_group.main.name
#   location               = azurerm_resource_group.main.location
#   account_tier           = "Standard"
#   replication_type       = "GRS"  # Geographic redundancy for production
#   container_name         = "prod-data"
#   folders                = ["catalogs", "raw", "processed", "curated"]
#   tags                   = merge(var.tags, { Environment = "production" })
# }

# module "prod_unity_catalog" {
#   source = "./modules/unity-catalog"
#   
#   managed_resource_group_name   = module.databricks_workspace.managed_resource_group_name
#   storage_account_id           = module.prod_storage.storage_account_id
#   storage_url                  = module.prod_storage.abfss_url
#   credential_name              = "prod-unity-catalog-credential"
#   external_location_name       = "prod-unity-catalog-external-location"
#   catalog_name                 = "prod"
#   catalog_comment              = "Production catalog for Unity Catalog"
#   
#   depends_on = [module.databricks_workspace, module.prod_storage]
# }

# Example: Staging Catalog with Separate Storage
# module "staging_storage" {
#   source = "./modules/storage-account"
#   
#   storage_account_prefix = "ststagingcatalog"
#   resource_group_name    = azurerm_resource_group.main.name
#   location               = azurerm_resource_group.main.location
#   account_tier           = "Standard"
#   replication_type       = "LRS"
#   container_name         = "staging-data"
#   folders                = ["catalogs", "testing"]
#   tags                   = merge(var.tags, { Environment = "staging" })
# }

# module "staging_unity_catalog" {
#   source = "./modules/unity-catalog"
#   
#   managed_resource_group_name   = module.databricks_workspace.managed_resource_group_name
#   storage_account_id           = module.staging_storage.storage_account_id
#   storage_url                  = module.staging_storage.abfss_url
#   credential_name              = "staging-unity-catalog-credential"
#   external_location_name       = "staging-unity-catalog-external-location"
#   catalog_name                 = "staging"
#   catalog_comment              = "Staging catalog for Unity Catalog"
#   
#   depends_on = [module.databricks_workspace, module.staging_storage]
# }

# Example: Team-specific Catalog (e.g., Data Science Team)
# module "datascience_storage" {
#   source = "./modules/storage-account"
#   
#   storage_account_prefix = "stdscatalog"
#   resource_group_name    = azurerm_resource_group.main.name
#   location               = azurerm_resource_group.main.location
#   account_tier           = "Standard"
#   replication_type       = "LRS"
#   container_name         = "datascience-data"
#   folders                = ["catalogs", "experiments", "models"]
#   tags                   = merge(var.tags, { Team = "data-science" })
# }

# module "datascience_unity_catalog" {
#   source = "./modules/unity-catalog"
#   
#   managed_resource_group_name   = module.databricks_workspace.managed_resource_group_name
#   storage_account_id           = module.datascience_storage.storage_account_id
#   storage_url                  = module.datascience_storage.abfss_url
#   credential_name              = "datascience-unity-catalog-credential"
#   external_location_name       = "datascience-unity-catalog-external-location"
#   catalog_name                 = "datascience"
#   catalog_comment              = "Data Science team catalog for Unity Catalog"
#   
#   depends_on = [module.databricks_workspace, module.datascience_storage]
# }

# Example outputs for additional catalogs
# output "prod_catalog_name" {
#   description = "Name of the production catalog"
#   value       = module.prod_unity_catalog.catalog_name
# }

# output "staging_catalog_name" {
#   description = "Name of the staging catalog"
#   value       = module.staging_unity_catalog.catalog_name
# }

# output "datascience_catalog_name" {
#   description = "Name of the data science catalog"
#   value       = module.datascience_unity_catalog.catalog_name
# }
#   source = "./modules/unity-catalog"
#   
#   managed_resource_group_name = module.databricks_workspace.managed_resource_group_name
#   storage_account_id          = module.staging_storage.storage_account_id
#   storage_url                 = module.staging_storage.abfss_url
#   
#   credential_name              = "staging-unity-catalog-credential"
#   credential_comment           = "Storage credential for staging Unity Catalog"
#   external_location_name       = "staging-unity-catalog-external-location"
#   external_location_comment    = "External location for staging Unity Catalog data storage"
#   catalog_name                 = "staging"
#   catalog_comment              = "Staging catalog for Unity Catalog"
#   
#   depends_on = [module.databricks_workspace, module.staging_storage]
# }