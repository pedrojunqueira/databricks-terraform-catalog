# Databricks Terraform Project

This project provisions an Azure Databricks workspace using Terraform Infrastructure as Code (IaC).

## 📋 Project Overview

- **Workspace### Usage in Databricks
Use these URLs when configuring Unity Catalog:
- **Metastore Root:** `abfss://data@stunitycatalogso4iniyd.dfs.core.windows.net/catalogs/`
- **External Locations:** `abfss://data@stunitycatalogso4iniyd.dfs.core.windows.net/`

## 🗂️ Unity Catalog Objects

The project automatically creates Unity Catalog objects for immediate use:

### Storage Credential
- **Name:** `unity-catalog-credential`
- **Type:** Azure Managed Identity
- **Access Connector:** Uses the Unity Catalog Access Connector
- **Purpose:** Authenticates to Azure storage using managed identity

### External Location
- **Name:** `unity-catalog-external-location`
- **URL:** `abfss://data@stunitycatalogso4iniyd.dfs.core.windows.net/`
- **Credential:** Managed by `unity-catalog-credential`
- **Purpose:** Defines external storage location for Unity Catalog

### Dev Catalog
- **Name:** `dev`
- **Storage Root:** Uses the external location URL
- **Purpose:** Development catalog for data assets
- **Usage:** Create schemas and tables using `dev.schema.table` namespace

### Ready to Use
Your Unity Catalog setup is complete and ready for## 🔒 Security Considerations

- **Service Principal:
- Creating schemas in the `dev` catalog
- Creating tables stored in Azure Data Lake
- Querying data with three-level namespace
- Managing permissions through Unity Catalog governance

## 🔒 Security Considerations** Limited to Contributor role on subscription
- **Environment Variables:** Stored in `.env` file (excluded from git)
- **Managed Identity:** Unity Catalog uses Azure managed identity for secure storage access
- **Storage Permissions:** Access connector has Storage Blob Data Contributor role
- **Unity Catalog Governance:** Three-level namespace with fine-grained permissions
- **Workspace Access:** Configure additional authentication as neededdataeng42-develop`
- **SKU:** Premium
- **Region:** Australia East
- **Resource Group:** `rg-databricks-dataeng42`
- **Storage Account:** `stunitycatalogso4iniyd` (Unity Catalog ready)
- **Data Container:** `data` with `catalogs` folder
- **Unity Catalog Objects:** Storage credential, external location, and dev catalog

## 🏗️ Infrastructure Components

- Azure Resource Group (`rg-databricks-dataeng42`)
- Azure Databricks Workspace (Premium) - **Module: databricks-workspace**
- Azure Storage Account V2 (`stunitycatalogso4iniyd`) - Data Lake Gen2 enabled - **Module: storage-account**
- Azure Managed Resource Group (`databricks-rg-rg-databricks-dataeng42`) - Auto-created by Databricks
- Unity Catalog Access Connector - Auto-created with proper permissions
- Unity Catalog Storage Credential (`unity-catalog-credential`) - **Module: unity-catalog**
- Unity Catalog External Location (`unity-catalog-external-location`) - **Module: unity-catalog**
- Unity Catalog Dev Catalog (`dev`) - **Module: unity-catalog**

## 🧩 Modular Architecture

This project uses a modular Terraform structure for maximum reusability and maintainability:

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
- **Reusability**: Deploy multiple catalogs with separate storage accounts
- **Isolation**: Each catalog can have its own dedicated storage and permissions
- **Maintainability**: Changes to one module don't affect others
- **Scalability**: Easy to add new environments (staging, prod) or teams
- **Consistency**: Standardized configurations across deployments

## 🚀 Getting Started

### Prerequisites

- Azure CLI installed and configured
- Terraform installed (>= 1.0)
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