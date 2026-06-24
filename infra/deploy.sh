#!/usr/bin/env bash
set -euo pipefail

RG="rg_hello-world"
LOCATION="canadacentral"
TEMPLATE_FILE="$(dirname "$0")/main.bicep"

echo "Creating resource group $RG in $LOCATION..."
az group create --name "$RG" --location "$LOCATION"

echo "Deploying Bicep template to $RG..."
az deployment group create --resource-group "$RG" --template-file "$TEMPLATE_FILE" --parameters location="$LOCATION"

echo "Deployment complete."
