#!/bin/bash

# Get the directory of the currently executing script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Define the path to the .env file in the parent directory
ENV_FILE="$SCRIPT_DIR/../.env"
# Check if the .env file exists in the parent directory
if [ -f "$ENV_FILE" ]; then
  # Load environment variables from the .env file
  set -o allexport
  source "$ENV_FILE"
  set +o allexport
fi

# Remove the prefix "Authorization=" from OTEL_EXPORTER_OTLP_HEADERS
FIXED_OTEL_EXPORTER_OTLP_HEADERS="${OTEL_EXPORTER_OTLP_HEADERS#Authorization=}"

# File to be updated
FILE="$SCRIPT_DIR/../iOS-MobileO11yDemo/iOS-MobileO11yDemo/Common/OpenTelemetry/OTelConfig.swift"

# New content
NEW_OTEL_HEADERS="    let otelHeaders = \"$FIXED_OTEL_EXPORTER_OTLP_HEADERS\""
NEW_ENDPOINT="    let endpointUrl = \"$OTEL_EXPORTER_OTLP_ENDPOINT\""

# Use sed to find and replace the line containing the prev string
sed -i '' "s|    let otelHeaders = \".*\"|$NEW_OTEL_HEADERS|" "$FILE"
sed -i '' "s|    let endpointUrl = \".*\"|$NEW_ENDPOINT|" "$FILE"

echo "Finished updating the iOS OpenTelemetry configuration."