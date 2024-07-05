# Azure Function App with Docker

This is a simple example of how to deploy an Azure Function App with an Azure Container Registry (ACR) and Docker.

## Getting Started

Build the Docker image and run it locally.

```bash
docker compose up
```

You can now access the api via `http://localhost:8080` and the function endpoint via `http://localhost:8080/api/httpTriggerTest`.

## Publish to Azure Container Registry (ACR) and Deploy to Azure Function App

What you need to do:

1. Login to Azure: `az login`
2. Update the variables in `deploy.sh`
3. Run the following command: `bash deploy.sh`

And there you go! You've deployed an Azure Function App with Docker.
