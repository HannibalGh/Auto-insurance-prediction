#!/bin/bash

# Set variables for the resource group, region, and project-specific names
RESOURCE_GROUP="AutoInsurancePredictionGroup"
LOCATION="uksouth"
STORAGE_ACCOUNT="autoclaimstoragelake"
BLOB_CONTAINER="source"  # Container in Blob Storage
DATA_LAKE_CONTAINER="target"  # Target container in Data Lake
DATABRICKS_WORKSPACE="AutoInsuranceDatabricksWS"
DATABRICKS_PLAN="standard"
SYNAPSE_WORKSPACE="autoinsurancesynapsews"
SYNAPSE_SQL_POOL="AutoInsuranceSQLPool"
AML_WORKSPACE="autoinsurancemlworkspace"
ADF_NAME="AutoInsuranceADF"
SUBSCRIPTION_ID="a07859c3-454d-4b3f-8813-97facfdd3422"  # Replace with your subscription ID
LOCAL_FILE_PATH="C:/Users/coolk/OneDrive/Desktop/Coding/Personal Projects/Coding Projects/Azure/Auto insurance prediction/Source/data/Car_Insurance_Claim.csv"  # Replace with the file path to your dataset
BLOB_NAME="Car_Insurance_Claim.csv"

# Login to Azure
echo "Logging into Azure..."
az login

# Set the Azure subscription
echo "Setting Azure subscription..."
az account set --subscription $SUBSCRIPTION_ID

# Create a resource group
echo "Creating resource group..."
az group create \
  --name $RESOURCE_GROUP \
  --location $LOCATION

# Create a storage account for Azure Data Lake Gen2
echo "Creating storage account..."
az storage account create \
  --name $STORAGE_ACCOUNT \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION \
  --sku Standard_LRS \
  --kind StorageV2 \
  --hns true  # Ensures the account is Data Lake Gen2 enabled

# Get storage account key
echo "Fetching storage account key..."
STORAGE_KEY=$(az storage account keys list \
  --resource-group $RESOURCE_GROUP \
  --account-name $STORAGE_ACCOUNT \
  --query "[0].value" \
  --output tsv)

# Create containers in Blob Storage and Data Lake Storage
echo "Creating containers in Blob and Data Lake..."
az storage container create --account-name $STORAGE_ACCOUNT --account-key $STORAGE_KEY --name $BLOB_CONTAINER
az storage container create --account-name $STORAGE_ACCOUNT --account-key $STORAGE_KEY --name $DATA_LAKE_CONTAINER

# Upload the local file to Azure Blob Storage
echo "Uploading local file to Azure Blob Storage..."
az storage blob upload \
  --account-name $STORAGE_ACCOUNT \
  --account-key $STORAGE_KEY \
  --container-name $BLOB_CONTAINER \
  --name $BLOB_NAME \
  --file "$LOCAL_FILE_PATH"

# Verify the uploaded file
echo "Verifying uploaded file..."
az storage blob list \
  --account-name $STORAGE_ACCOUNT \
  --container-name $BLOB_CONTAINER \
  --output table

# Create an Azure Data Factory instance
echo "Creating Azure Data Factory..."
az datafactory create \
  --resource-group $RESOURCE_GROUP \
  --name $ADF_NAME \
  --location $LOCATION

# Create a linked service for Blob Storage
echo "Creating linked service for Blob Storage..."
az datafactory linked-service create \
  --resource-group $RESOURCE_GROUP \
  --factory-name $ADF_NAME \
  --name BlobStorageLinkedService \
  --properties '{
    "type": "AzureBlobStorage",
    "typeProperties": {
      "connectionString": "'$(az storage account show-connection-string --resource-group $RESOURCE_GROUP --name $STORAGE_ACCOUNT --query connectionString --output tsv)'"
    }
  }'

# Create dataset for Blob Storage (Source)
echo "Creating dataset for Blob Storage (Source)..."
az datafactory dataset create \
  --resource-group $RESOURCE_GROUP \
  --factory-name $ADF_NAME \
  --name BlobDataset \
  --properties '{
    "linkedServiceName": {
      "referenceName": "BlobStorageLinkedService",
      "type": "LinkedServiceReference"
    },
    "type": "Binary",
    "typeProperties": {
      "folderPath": "'$BLOB_CONTAINER'",
      "fileName": "'$BLOB_NAME'"
    }
  }'

# Create dataset for Data Lake Storage (Sink)
echo "Creating dataset for Data Lake Storage (Sink)..."
az datafactory dataset create \
  --resource-group $RESOURCE_GROUP \
  --factory-name $ADF_NAME \
  --name DataLakeDataset \
  --properties '{
    "linkedServiceName": {
      "referenceName": "BlobStorageLinkedService",
      "type": "LinkedServiceReference"
    },
    "type": "Binary",
    "typeProperties": {
      "folderPath": "'$DATA_LAKE_CONTAINER'"
    }
  }'

# Create a pipeline in ADF to copy from Blob to Data Lake
echo "Creating pipeline in ADF..."
az datafactory pipeline create \
  --resource-group $RESOURCE_GROUP \
  --factory-name $ADF_NAME \
  --name CopyPipeline \
  --pipeline '{
    "activities": [
      {
        "name": "CopyFromBlobToDataLake",
        "type": "Copy",
        "inputs": [
          {
            "referenceName": "BlobDataset",
            "type": "DatasetReference"
          }
        ],
        "outputs": [
          {
            "referenceName": "DataLakeDataset",
            "type": "DatasetReference"
          }
        ],
        "typeProperties": {
          "source": {
            "type": "BlobSource"
          },
          "sink": {
            "type": "BlobSink"
          }
        }
      }
    ]
  }'

# Create a scheduled trigger to run the pipeline at midday (12:00 PM) every day
echo "Creating scheduled trigger for the pipeline..."
az datafactory trigger create \
  --resource-group $RESOURCE_GROUP \
  --factory-name $ADF_NAME \
  --name MiddayTrigger \
  --properties '{
    "type": "ScheduleTrigger",
    "typeProperties": {
      "recurrence": {
        "frequency": "Day",
        "interval": 1,
        "startTime": "2024-09-10T12:00:00Z"  # Change the date to current date
      },
      "pipeline": {
        "referenceName": "CopyPipeline",
        "type": "PipelineReference"
      }
    }
  }'

# Start the trigger
echo "Starting the scheduled trigger..."
az datafactory trigger run \
  --resource-group $RESOURCE_GROUP \
  --factory-name $ADF_NAME \
  --name MiddayTrigger


# Create an Azure Databricks workspace
echo "Creating Databricks workspace..."
az databricks workspace create \
  --resource-group $RESOURCE_GROUP \
  --name $DATABRICKS_WORKSPACE \
  --location $LOCATION \
  --sku $DATABRICKS_PLAN
