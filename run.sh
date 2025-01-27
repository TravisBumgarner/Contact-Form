#!/bin/bash

# Set the working directory to the script's location
cd "$(dirname "$0")"

# Install production dependencies if they're not already installed
if [ ! -d "node_modules" ]; then
    npm ci --only=production
fi

# Start the server using Node (not ts-node since we're using the built version)
exec node dist/index.js
