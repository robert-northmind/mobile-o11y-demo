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

# File to be created
FILE="$SCRIPT_DIR/../Mobiles/flutter/.env"

# Write environment variables to the file
echo "FARO_API_KEY=$FARO_API_KEY" > $FILE
echo "FARO_COLLECTOR_URL=$FARO_COLLECTOR_URL" >> $FILE

# Print a message indicating success
echo "✅ Finished updating the Flutter Faro configuration."