#!/bin/bash

# Run the command and filter the lines
output=$(ps -e | grep 'node --require @opentelemetry/auto-instrumentations-node/register server.js')

# Extract PIDs and kill the processes
echo "$output" | while read -r line; do
  # Extract the PID (the first number on the line)
  pid=$(echo "$line" | awk '{print $1}')

  # Kill the process
  kill -9 "$pid"
  
  # Print the action for confirmation
  echo "Killed process with PID: $pid"
done