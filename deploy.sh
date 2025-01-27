#!/bin/bash

# Load environment variables from .env file
if [ -f .env ]; then
    export $(cat .env | grep -v '#' | xargs)
else
    echo "Error: .env file not found"
    exit 1
fi

# Define variables
REMOTE_DIR="/home/contact-form"
REPO_URL="your-repository-url-here"
TEMP_DIR="/tmp/contact-form-build"
BRANCH="main"

# Execute remote commands
echo "Starting remote deployment..."
ssh $DEPLOY_SERVER_USER@$DEPLOY_SERVER_HOST "
    # Clean up any existing temp directory
    echo 'Cleaning up any existing temp directory...'
    rm -rf $TEMP_DIR

    # Clone the repository
    echo 'Cloning repository...'
    git clone $REPO_URL $TEMP_DIR

    # Change to the project directory
    cd $TEMP_DIR
    git checkout $BRANCH

    # Install dependencies and build
    echo 'Installing dependencies...'
    npm install

    echo 'Building application...'
    npm run build

    # Move files to deployment directory
    echo 'Moving files to deployment directory...'
    rm -rf $REMOTE_DIR/*
    rm -rf $REMOTE_DIR/.* 2>/dev/null

    mv dist run.sh package.json package-lock.json .env $REMOTE_DIR/

    # Install production dependencies in deployment directory
    cd $REMOTE_DIR
    npm install --production
    chmod +x run.sh

    # Clean up
    echo 'Cleaning up...'
    rm -rf $TEMP_DIR
"

echo "Deployment complete!"
