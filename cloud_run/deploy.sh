#!/usr/bin/env bash
set -euo pipefail

# Optional variables for service name and region
SERVICE_NAME=${SERVICE_NAME:-my-service}
DEPLOY_REGION=${DEPLOY_REGION:-us-central1}

PROJECT_ID=$(gcloud config get-value project)
IMAGE="gcr.io/${PROJECT_ID}/${SERVICE_NAME}"

# Build container image
printf 'Building %s...\n' "$IMAGE"
gcloud builds submit --tag "$IMAGE" .

# Deploy to Cloud Run
printf 'Deploying service %s to region %s...\n' "$SERVICE_NAME" "$DEPLOY_REGION"
gcloud run deploy "$SERVICE_NAME" --image "$IMAGE" --region "$DEPLOY_REGION" --platform managed --quiet