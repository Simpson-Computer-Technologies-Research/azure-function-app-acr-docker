# Define variables
DOCKER_ID="your-docker-id" # Your Docker username (ID)

ACR_REGISTRY_NAME="change-me" # This is the name of your ACR registry
ACR_LOGIN_SERVER=${ACR_REGISTRY_NAME}.azurecr.io
ACR_IMAGE_NAME="azurefunctionsimage" # This can be anything you want
ACR_IMAGE_VERSION="v1.0.0" # This can be anything you want

RESOURCE_GROUP="change-me" # This is the name of your resource group
FUNCTION_APP_NAME="change-me" # This is the name of your function app

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

# This will update the deployment with the new image
az functionapp config container set --image ${ACR_IMAGE_NAME} --registry-password ${ACR_PASSWORD} --registry-username ${ACR_REGISTRY_NAME} --name ${FUNCTION_APP_NAME} --resource-group ${RESOURCE_GROUP}