#!/bin/bash

# Variables
RESOURCE_GROUP="your-resource-group"
ACR_NAME="your-acr-name"
ACR_LOGIN_SERVER="your-acr-login-server.azurecr.io"
FUNCTION_APP_NAME="your-function-app-name"
IMAGE_NAME="your-image-name"
TAG="latest"

# Login to Azure
az login

# Ensure the ACR is logged in
az acr login --name $ACR_NAME

# Build the Docker image
docker build -t $ACR_LOGIN_SERVER/$IMAGE_NAME:$TAG .

# Push the Docker image to ACR
docker push $ACR_LOGIN_SERVER/$IMAGE_NAME:$TAG

# Update the Azure Function App to use the new image
az functionapp config container set \
    --name $FUNCTION_APP_NAME \
    --resource-group $RESOURCE_GROUP \
    --docker-custom-image-name $ACR_LOGIN_SERVER/$IMAGE_NAME:$TAG \
    --docker-registry-server-url https://$ACR_LOGIN_SERVER

echo "Deployment to Azure Function App is complete."