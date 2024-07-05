# Azure Function App with Docker

This is a simple example of how to deploy an Azure Function App with an Azure Container Registry (ACR) and Docker.

## Getting Started

Build the Docker image and run it locally.

```bash
docker compose up
```

You can now access the api via `http://localhost:8080` and the function endpoint via `http://localhost:8080/api/httpTriggerTest`.

## Publish to Azure Container Registry (ACR) and Deploy to Azure Function App

You'll need to first create an Azure Container Registry (ACR). This can be done via the Azure Portal or Azure CLI.

### Bash

Luckily, I've already made a script that includes all of the commands from [Azure CLI](#azure-cli). All you need to do is update the variables in `deploy.sh` and run the following command:

```bash
sh deploy.sh
```

### Azure CLI

Otherwise, here's all of the commands...

```bash
# Define variables
DOCKER_ID="your-docker-id" # Your Docker username (ID)
ACR_REGISTRY_NAME="change-me" # This is the name of your ACR registry
ACR_LOGIN_SERVER="${ACR_REGISTRY_NAME}.azurecr.io"
ACR_IMAGE_NAME="azurefunctionsimage" # This can be anything you want
ACR_IMAGE_VERSION="v1.0.0" # This can be anything you want

# Login to the ACR registry
az acr login --name ${ACR_REGISTRY_NAME}

# Build the image
docker build --tag ${ACR_LOGIN_SERVER}/${ACR_IMAGE_NAME}:${ACR_IMAGE_VERSION} .

# Push the image to ACR
docker push ${ACR_LOGIN_SERVER}/${ACR_IMAGE_NAME}:${ACR_IMAGE_VERSION}

# Enable admin user
az acr update -n ${ACR_REGISTRY_NAME} --admin-enabled true

# Get the password
ACR_PASSWORD=$(az acr credential show --name ${ACR_REGISTRY_NAME} --query "passwords[0].value" --output tsv)
```

#### Deploy to Azure Function App

You'll need to first create an Azure Function App and Resource Group. This can be done via the Azure Portal or Azure CLI.

The following commands use variables from [Publish to Azure Container Registry (ACR)](#publish-to-azure-container-registry-acr).

```bash
RESOURCE_GROUP="change-me" # This is the name of your resource group
FUNCTION_APP_NAME="change-me" # This is the name of your function app

# This will update the deployment with the new image
az functionapp config container set --image ${ACR_IMAGE_NAME} --registry-password ${ACR_PASSWORD} --registry-username ${ACR_REGISTRY_NAME} --name ${FUNCTION_APP_NAME} --resource-group ${RESOURCE_GROUP}
```

And there you go! You've deployed an Azure Function App with Docker.

> If you get an error, you may need to login to azure: `az login`
