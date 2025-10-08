# Databricks Unity Catalog Terraform Project

This project provisions a complete Azure Databricks workspace with Unity Catalog using Terraform Infrastructure as Code (IaC). The modular architecture enables reusable deployments for multiple catalogs and environments.

## 📋 Project Overview

- **Workspace Name:** `dataeng42-develop`
- **SKU:** Premium
- **Region:** Australia East
- **Resource Group:** `rg-databricks-dataeng42`
- **Storage Account:** Data Lake Gen2 enabled for Unity Catalog
- **Unity Catalog:** Complete setup with dev catalog ready to use

## 🏗️ Infrastructure Components

### Azure Resources
- **Resource Group** (`rg-databricks-dataeng42`)
- **Databricks Workspace** (Premium) - Module: `databricks-workspace`
- **Storage Account V2** with Data Lake Gen2 - Module: `storage-account`
- **Managed Resource Group** (auto-created by Databricks)

### Unity Catalog Components
- **Access Connector** (auto-created with proper permissions)
- **Storage Credential** (`unity-catalog-credential`) - Module: `unity-catalog`
- **External Location** (`unity-catalog-external-location`) - Module: `unity-catalog`
- **Dev Catalog** (`dev`) - Module: `unity-catalog`

## 🧩 Modular Architecture

### **Module: databricks-workspace**
- Creates Azure Databricks workspace
- Configurable SKU, location, and tags
- Outputs workspace details and managed resource group info

### **Module: storage-account**
- Creates Azure Storage Account V2 with Data Lake Gen2
- Configurable storage tier, replication, and folder structure
- Supports multiple containers and custom folder layouts
- Generates unique storage account names

### **Module: unity-catalog**
- Creates Unity Catalog storage credential using access connector
- Creates external location pointing to storage account
- Creates Unity Catalog with proper governance setup
- Assigns necessary permissions automatically

### **Benefits of Modular Design:**
- ✅ **Reusability**: Deploy multiple catalogs with separate storage accounts
- ✅ **Isolation**: Each catalog can have its own dedicated storage and permissions
- ✅ **Maintainability**: Changes to one module don't affect others
- ✅ **Scalability**: Easy to add new environments (staging, prod) or teams
- ✅ **Consistency**: Standardized configurations across deployments

## 📁 Project Structure

```
databricks-terraform-catalog/
├── .env                    # Environment variables (not in git)
├── .gitignore             # Git ignore patterns
├── main.tf               # Complete deployment configuration
├── outputs.tf            # Output definitions
├── variables.tf          # Variable definitions
├── examples.tf           # Examples for additional catalogs
├── README.md            # This documentation
└── modules/
    ├── databricks-workspace/  # Workspace module
    ├── storage-account/       # Storage module
    └── unity-catalog/         # Unity Catalog module
```

## 🚀 Getting Started

### Prerequisites

1. **Azure CLI** installed and authenticated: `az login`
2. **Terraform >= 1.0** installed
3. **Active Azure subscription**
4. **Service Principal** with Contributor permissions

### Step 1: Create Azure Service Principal

```bash
# Login to Azure
az login

# Create service principal with contributor role
az ad sp create-for-rbac \
  --name "databricks-terraform-sp" \
  --role contributor \
  --scopes /subscriptions/<your-subscription-id>
```

**Important:** Save the output containing:
- `appId` (Client ID)
- `password` (Client Secret)  
- `tenant` (Tenant ID)

### Step 2: Configure Environment Variables

Create a `.env` file with your Azure credentials:

```bash
# Azure Service Principal credentials for Terraform
ARM_CLIENT_ID="your-app-id-here"
ARM_CLIENT_SECRET="your-password-here"
ARM_TENANT_ID="your-tenant-id-here"
ARM_SUBSCRIPTION_ID="your-subscription-id-here"
```

Load the environment variables:

```bash
source .env
```

## 🎯 Deployment Process

Due to provider dependencies, deployment requires **two steps** to resolve circular dependency issues.

### Step 1: Deploy Infrastructure Foundation

Deploy the core infrastructure (Resource Group, Databricks Workspace, Storage Account):

```bash
# Initialize Terraform
terraform init

# Deploy infrastructure foundation
terraform apply -target=azurerm_resource_group.main -target=module.databricks_workspace -target=module.dev_storage
```

**What this deploys:**
- ✅ Azure Resource Group
- ✅ Databricks Premium Workspace  
- ✅ Storage Account with Data Lake Gen2
- ✅ Storage containers and folder structure

### Step 2: Deploy Unity Catalog

After the workspace is created and accessible, deploy Unity Catalog:

```bash
terraform apply
```

**What this deploys:**
- ✅ Unity Catalog Access Connector (uses existing)
- ✅ Storage Credential
- ✅ External Location
- ✅ Unity Catalog (dev)
- ✅ Default Schema (dev.default)

### Why Two Steps?

The Databricks provider needs to connect to an existing workspace to create Unity Catalog resources. This creates a circular dependency:

- **Unity Catalog** resources need → **Databricks Provider** configured
- **Databricks Provider** needs → **Workspace URL** (from workspace resource)  
- **Workspace URL** comes from → **Workspace creation** (same Terraform run)

The two-step approach resolves this by ensuring the workspace exists before the provider tries to connect to it.

## 🔧 Configuration Files

### `main.tf`
Contains the complete infrastructure configuration including:
- Terraform and provider requirements
- Azure Resource Group
- Databricks workspace module
- Storage account module  
- Unity Catalog module with proper dependencies

### `variables.tf`
Defines configurable variables:
- `location` - Azure region (default: australiaeast)
- `resource_group_name` - Resource group name
- `databricks_workspace_name` - Workspace name
- `databricks_sku` - Workspace SKU (default: premium)
- `storage_account_tier` - Storage performance tier (default: Standard)
- `storage_replication_type` - Storage replication (default: LRS)
- `tags` - Resource tags

### `outputs.tf`
Exports important resource information:
- Databricks workspace ID and URL
- Resource group and managed resource group names
- Storage account details and endpoints
- Unity Catalog access connector information
- Unity Catalog objects (credential, external location, catalog)

## 🎯 Deployment Outputs

After successful deployment, you'll receive:

### Infrastructure Outputs
- **Workspace URL:** Access point to your Databricks workspace
- **Workspace ID:** Azure resource identifier
- **Resource Group:** Container for all resources
- **Managed Resource Group:** Auto-created by Databricks

### Storage Outputs  
- **Storage Account Name:** Unique storage account identifier
- **Storage Account ID:** Azure resource identifier
- **Primary DFS Endpoint:** Data Lake Gen2 endpoint
- **ABFSS URL:** Complete storage URL for Unity Catalog

### Unity Catalog Outputs
- **Access Connector ID:** Managed identity for storage access
- **Principal ID:** Service principal for permissions
- **Storage Credential:** `unity-catalog-credential` for authentication
- **External Location:** `unity-catalog-external-location` pointing to storage
- **Dev Catalog:** `dev` catalog ready for schemas and tables
- **Default Schema:** `dev.default` schema automatically created
- **Schema Full Name:** Complete schema reference for SQL queries

## 🗂️ Unity Catalog Setup

### Storage Configuration
- **Storage Account:** Data Lake Gen2 with hierarchical namespace
- **Container:** `data` with `catalogs` folder pre-created
- **Permissions:** Unity Catalog access connector has Storage Blob Data Contributor role

### Unity Catalog Objects
- **Storage Credential:** Uses Azure managed identity via access connector
- **External Location:** Points to the storage account container
- **Dev Catalog:** Ready for creating schemas and tables
- **Default Schema:** `dev.default` schema automatically created and ready to use

### Ready to Use
Your Unity Catalog setup is complete and ready for:
- **Immediate table creation** in the `dev.default` schema (no additional setup needed)
- Creating additional schemas in the `dev` catalog
- Creating tables stored in Azure Data Lake
- Querying data with three-level namespace (`dev.default.table` or `dev.schema.table`)
- Managing permissions through Unity Catalog governance

### Quick Start Examples
```sql
-- Create a table in the default schema (immediately available)
CREATE TABLE dev.default.my_first_table (
    id INT,
    name STRING,
    created_at TIMESTAMP
) USING DELTA;

-- Query the table
SELECT * FROM dev.default.my_first_table;

-- Create additional schemas if needed
CREATE SCHEMA dev.analytics;
CREATE TABLE dev.analytics.sales_data (id INT, amount DECIMAL) USING DELTA;
```

## ✅ Verification

After successful deployment, verify:

1. **Workspace Access**: Login to your Databricks workspace using the output URL
2. **Unity Catalog**: Navigate to Data Explorer and check that the `dev` catalog exists
3. **Default Schema**: Verify the `dev.default` schema is created and accessible
4. **Storage**: Verify external location is accessible in Unity Catalog settings
5. **Table Creation**: Test creating a table in `dev.default` schema to confirm full functionality

## 🔍 Troubleshooting

### Provider Authentication Issues
If you get authentication errors in Step 2:
```bash
# Verify your service principal has workspace access
az role assignment list --assignee $ARM_CLIENT_ID --scope /subscriptions/$ARM_SUBSCRIPTION_ID

# Check environment variables are loaded
echo $ARM_CLIENT_ID
```

### Workspace Connection Issues
If the Databricks provider can't connect:
```bash
# Check workspace is accessible
az databricks workspace show --resource-group rg-databricks-dataeng42 --name dataeng42-develop

# Verify workspace URL from outputs
terraform output databricks_workspace_url
```

### Common Issues

1. **Resource Naming Conflicts**
   - Databricks workspace names must be globally unique
   - Modify `databricks_workspace_name` variable if needed

2. **Region Availability**  
   - Ensure Databricks is available in your selected region
   - Check Azure service availability by region

3. **Storage Account Name Conflicts**
   - Storage account names are auto-generated with random suffix
   - If conflicts occur, run `terraform apply` again to generate new suffix

## 🔒 Security Considerations

- **Service Principal:** Limited to Contributor role on subscription
- **Environment Variables:** Stored in `.env` file (excluded from git)
- **Managed Identity:** Unity Catalog uses Azure managed identity for secure storage access
- **Storage Permissions:** Access connector has Storage Blob Data Contributor role
- **Unity Catalog Governance:** Three-level namespace with fine-grained permissions
- **Workspace Access:** Configure additional authentication as needed

## 📝 Customization

To modify the deployment:

1. Update variables in `variables.tf`
2. Run `terraform plan` to review changes  
3. Run `terraform apply` to implement changes

### Adding Additional Catalogs

Use the examples in `examples.tf` to deploy additional catalogs with separate storage accounts:

```hcl
# Additional catalog with dedicated storage
module "prod_storage" {
  source = "./modules/storage-account"
  # ... configuration
}

module "prod_unity_catalog" {
  source = "./modules/unity-catalog"
  # ... configuration
}
```

## 🧹 Cleanup

To destroy all resources:

```bash
terraform destroy
```

**Warning:** This will permanently delete all resources including:
- Databricks workspace and all notebooks/clusters
- Storage account and all data
- Unity Catalog metadata
- All associated Azure resources

Note: Destroy will remove Unity Catalog first, then the workspace and storage.

## 📚 Additional Resources

- [Azure Databricks Documentation](https://docs.microsoft.com/en-us/azure/databricks/)
- [Unity Catalog Documentation](https://docs.databricks.com/data-governance/unity-catalog/index.html)
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest)
- [Terraform Databricks Provider](https://registry.terraform.io/providers/databricks/databricks/latest)
- [Azure CLI Reference](https://docs.microsoft.com/en-us/cli/azure/)

---

**Created:** October 2025  
**Managed By:** Terraform  
**Project:** dataeng42  
**Architecture:** Modular Unity Catalog Setup
- An active Azure subscription

### Step 1: Create Azure Service Principal

First, log into Azure and create a service principal for Terraform authentication:

```bash
# Login to Azure
az login

# Create service principal with contributor role
az ad sp create-for-rbac \
  --name "databricks-terraform-sp" \
  --role contributor \
  --scopes /subscriptions/<your-subscription-id>
```

**Important:** Save the output containing:
- `appId` (Client ID)
- `password` (Client Secret)
- `tenant` (Tenant ID)

### Step 2: Configure Environment Variables

Create a `.env` file with your Azure credentials:

```bash
# Azure Service Principal credentials for Terraform
ARM_CLIENT_ID="your-app-id-here"
ARM_CLIENT_SECRET="your-password-here"
ARM_TENANT_ID="your-tenant-id-here"
ARM_SUBSCRIPTION_ID="your-subscription-id-here"
```

Load the environment variables:

```bash
source .env
```

### Step 3: Deploy Infrastructure

Initialize and apply the Terraform configuration in two steps:

```bash
# Initialize Terraform
terraform init

# Step 1: Deploy workspace and storage infrastructure
terraform apply -target=module.databricks_workspace -target=module.dev_storage

# Step 2: Uncomment Unity Catalog configuration in unity_catalog_step2.tf
# Then apply Unity Catalog objects
terraform apply
```

**Why Two Steps?**
The Databricks provider needs an existing workspace to connect to. This two-step approach ensures the workspace exists before configuring Unity Catalog objects.

## 📁 Project Structure

```
databricks-terraform-catalog/
├── .env                       # Environment variables (not in git)
├── .gitignore                # Git ignore patterns
├── main.tf                   # Main deployment (workspace + storage)
├── unity_catalog_step2.tf    # Unity Catalog objects (deploy after workspace)
├── outputs.tf               # Output definitions
├── variables.tf             # Variable definitions
├── examples.tf              # Examples for additional catalogs
├── README.md               # This file
└── modules/
    ├── databricks-workspace/ # Workspace module
    ├── storage-account/      # Storage module
    └── unity-catalog/        # Unity Catalog module
```

## 🔧 Configuration Files

### `main.tf`
Contains the Terraform, Azure, and Databricks provider configuration.

### `variables.tf`
Defines configurable variables:
- `location` - Azure region (default: australiaeast)
- `resource_group_name` - Resource group name
- `databricks_workspace_name` - Workspace name
- `databricks_sku` - Workspace SKU (default: premium)
- `storage_account_tier` - Storage performance tier (default: Standard)
- `storage_replication_type` - Storage replication (default: LRS)
- `tags` - Resource tags

### `databricks.tf`
Defines the Azure resources:
- Resource Group
- Databricks Workspace

### `storage.tf`
Defines Unity Catalog storage resources:
- Azure Storage Account V2 with hierarchical namespace
- Data Lake Gen2 filesystem and folder structure
- Role assignments for Unity Catalog access connector

### `unity_catalog.tf`
Defines Unity Catalog objects:
- Storage credential using Azure managed identity
- External location pointing to the storage account
- Dev catalog for data assets

### `outputs.tf`
Exports important resource information:
- Databricks workspace ID and URL
- Resource group name
- Storage account details and endpoints
- Unity Catalog access connector information
- Unity Catalog objects (credential, external location, catalog)

## 🎯 Deployment Outputs

After successful deployment, you'll receive:

- **Workspace URL:** Access point to your Databricks workspace
- **Workspace ID:** Azure resource identifier
- **Resource Group:** Container for all resources
- **Storage Account:** Data Lake Gen2 storage for Unity Catalog
- **Storage Endpoints:** DFS endpoint for data access
- **Unity Catalog Access Connector:** With proper storage permissions
- **Storage Credential:** `unity-catalog-credential` for authentication
- **External Location:** `unity-catalog-external-location` pointing to storage
- **Dev Catalog:** `dev` catalog ready for schemas and tables
- **Managed Resource Group:** `databricks-rg-rg-databricks-dataeng42` (auto-created by Azure)

## 🏭 Managed Resource Group Details

Azure Databricks automatically creates a managed resource group that contains underlying infrastructure:

- **Name:** `databricks-rg-rg-databricks-dataeng42`
- **Purpose:** Houses compute resources, storage, and networking components
- **Contents:**
  - Virtual machines for clusters
  - Network security groups and virtual networks
  - Storage accounts for cluster logs and temp data
  - Unity Catalog access connectors (when enabled)

**⚠️ Important:** This managed resource group is controlled by Azure Databricks service. Do not modify resources directly - manage them through the Databricks workspace interface.

## �️ Unity Catalog Configuration

The project automatically sets up Unity Catalog-ready storage infrastructure:

### Storage Account Details
- **Name:** `stunitycatalogso4iniyd` (dynamically generated)
- **Type:** Azure Data Lake Storage Gen2 (StorageV2 with hierarchical namespace)
- **Container:** `data` with `catalogs` folder pre-created
- **Endpoint:** `https://stunitycatalogso4iniyd.dfs.core.windows.net/`

### Access Configuration
- **Unity Catalog Access Connector:** Automatically discovered from managed resource group
- **Permissions:** Storage Blob Data Contributor role assigned
- **Managed Identity:** `115f5969-fad7-417e-8303-263393f6c869`

### Usage in Databricks
Use these URLs when configuring Unity Catalog:
- **Metastore Root:** `abfss://data@stunitycatalogso4iniyd.dfs.core.windows.net/catalogs/`
- **External Locations:** `abfss://data@stunitycatalogso4iniyd.dfs.core.windows.net/`

## �🔒 Security Considerations

- **Service Principal:** Limited to Contributor role on subscription
- **Environment Variables:** Stored in `.env` file (excluded from git)
- **Workspace Access:** Configure additional authentication as needed

## 🧹 Cleanup

To destroy the infrastructure:

```bash
terraform destroy
```

**Warning:** This will permanently delete all resources created by this project.

## 📝 Customization

To modify the deployment:

1. Update variables in `variables.tf`
2. Run `terraform plan` to review changes
3. Run `terraform apply` to implement changes

## 🔍 Troubleshooting

### Common Issues

1. **Authentication Errors**
   - Verify environment variables are loaded: `echo $ARM_CLIENT_ID`
   - Check service principal permissions in Azure portal

2. **Resource Naming Conflicts**
   - Databricks workspace names must be globally unique
   - Modify `databricks_workspace_name` variable if needed

3. **Region Availability**
   - Ensure Databricks is available in your selected region
   - Check Azure service availability by region

## 📚 Additional Resources

- [Azure Databricks Documentation](https://docs.microsoft.com/en-us/azure/databricks/)
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest)
- [Azure CLI Reference](https://docs.microsoft.com/en-us/cli/azure/)

---

**Created:** October 2025  
**Managed By:** Terraform  
**Project:** dataeng42