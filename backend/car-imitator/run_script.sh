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

export OTEL_SERVICE_NAME="car-imitator"

export OTEL_EXPORTER_OTLP_PROTOCOL="http/protobuf"
export OTEL_TRACES_EXPORTER="otlp"
export OTEL_METRICS_EXPORTER="otlp"
export NODE_OPTIONS="--require @opentelemetry/auto-instrumentations-node/register"

node --require @opentelemetry/auto-instrumentations-node/register server.js
