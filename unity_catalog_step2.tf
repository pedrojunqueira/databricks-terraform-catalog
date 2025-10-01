# Unity Catalog Configuration
# 
# IMPORTANT: This should be uncommented and applied AFTER the initial deployment
# 
# Step 1: Deploy workspace and storage with: terraform apply -target=module.databricks_workspace -target=module.dev_storage
# Step 2: Uncomment this section and run: terraform apply
#
# This two-step approach ensures the Databricks workspace exists before configuring Unity Catalog

# # Databricks provider for Unity Catalog configuration
# provider "databricks" {
#   alias                       = "workspace"
#   host                        = module.databricks_workspace.workspace_url
#   azure_workspace_resource_id = module.databricks_workspace.workspace_id
# }

# # Unity Catalog for Dev
# module "dev_unity_catalog" {
#   source = "./modules/unity-catalog"
#   
#   providers = {
#     databricks = databricks.workspace
#   }
#   
#   managed_resource_group_name   = module.databricks_workspace.managed_resource_group_name
#   storage_account_id           = module.dev_storage.storage_account_id
#   storage_url                  = module.dev_storage.abfss_url
#   credential_name              = "unity-catalog-credential"
#   external_location_name       = "unity-catalog-external-location"
#   catalog_name                 = "dev"
#   catalog_comment              = "Development catalog for Unity Catalog"
#   
#   depends_on = [module.databricks_workspace, module.dev_storage]
# }