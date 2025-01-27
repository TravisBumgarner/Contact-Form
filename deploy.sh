#!/bin/bash

# Load environment variables from .env file
if [ -f .env ]; then
    export $(cat .env.nfs | grep -v '#' | xargs)
else
    echo "Error: .env.nfs file not found"
    exit 1
fi

# Define variables
REMOTE_DIR="/home/protected/"

# Execute remote commands
echo "Starting remote deployment..."

# Upload .env file and build directory
echo "Uploading files..."
scp .env $DEPLOY_SERVER_USER@$DEPLOY_SERVER_HOST:$REMOTE_DIR/.env
scp -r build/ $DEPLOY_SERVER_USER@$DEPLOY_SERVER_HOST:$REMOTE_DIR/
scp package.json $DEPLOY_SERVER_USER@$DEPLOY_SERVER_HOST:$REMOTE_DIR/
scp run.sh $DEPLOY_SERVER_USER@$DEPLOY_SERVER_HOST:$REMOTE_DIR/

ssh $DEPLOY_SERVER_USER@$DEPLOY_SERVER_HOST "
    cd $REMOTE_DIR
    
    # Install dependencies
    npm install --production
    
    # Make sure run script is executable
    chmod +x run.sh

    # Clean up
    echo 'Cleaning up...'
    rm -rf $TEMP_DIR
"

echo "Deployment complete!"
