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

# Files to be updated
OTEL_FILE="$SCRIPT_DIR/../Mobiles/ios/iOS-MobileO11yDemo/Common/OpenTelemetry/OTelConfig.swift"
FARO_FILE="$SCRIPT_DIR/../Mobiles/ios/iOS-MobileO11yDemo/Common/OpenTelemetry/FaroConfig.swift"

# New content for OTelConfig
NEW_OTEL_HEADERS="    let otelHeaders = \"$FIXED_OTEL_EXPORTER_OTLP_HEADERS\""
NEW_ENDPOINT="    let endpointUrl = \"$OTEL_EXPORTER_OTLP_ENDPOINT\""

# New content for FaroConfig
NEW_FARO_COLLECTOR_URL="    let collectorUrl = \"$FARO_COLLECTOR_URL\""

# Use sed to find and replace the line containing the prev string in OTelConfig
sed -i '' "s|    let otelHeaders = \".*\"|$NEW_OTEL_HEADERS|" "$OTEL_FILE"
sed -i '' "s|    let endpointUrl = \".*\"|$NEW_ENDPOINT|" "$OTEL_FILE"

# Use sed to find and replace the line containing collectorUrl in FaroConfig
sed -i '' "s|    let collectorUrl = \".*\"|$NEW_FARO_COLLECTOR_URL|" "$FARO_FILE"

echo "✅ Finished updating the iOS OpenTelemetry and Faro configurations."