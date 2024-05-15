#!/bin/bash

# Define the path to the .env file in the parent directory
ENV_FILE="../../.env"
# Check if the .env file exists in the parent directory
if [ -f "$ENV_FILE" ]; then
  # Load environment variables from the .env file
  set -o allexport
  source "$ENV_FILE"
  set +o allexport
fi

export OTEL_SERVICE_NAME="observable-motor-command"

node --require @opentelemetry/auto-instrumentations-node/register server.js
