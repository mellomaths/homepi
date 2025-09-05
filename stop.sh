#!/bin/bash

# Check if a parameter is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <application_name>"
    echo "Example: $0 glance"
    exit 1
fi

# Get the application name from the first parameter
APPLICATION="$1"
FOLDER_PATH=""

# Check if the application is valid
if [ "$APPLICATION" == "glance" ]; then
    FOLDER_PATH="dashboards/glance"
fi

if [ "$APPLICATION" == "portainer" ]; then
    FOLDER_PATH="dashboards/portainer"
fi


if [ "$FOLDER_PATH" == "" ]; then
    echo "Error: Application '$APPLICATION' is not valid"
    exit 1
fi

# Check if the folder exists
if [ ! -d "$FOLDER_PATH" ]; then
    echo "Error: Folder '$FOLDER_PATH' does not exist"
    exit 1
fi

# Check if docker-compose.yml exists in the folder
if [ ! -f "$FOLDER_PATH/docker-compose.yml" ]; then
    echo "Error: docker-compose.yml not found in '$FOLDER_PATH'"
    exit 1
fi

echo "Stopping Docker Compose in folder: $FOLDER_PATH"

# Navigate to the folder and run docker compose down
cd "$FOLDER_PATH" && docker compose down

# Check if the command was successful
if [ $? -eq 0 ]; then
    echo "Docker Compose stopped successfully in $FOLDER_PATH"
else
    echo "Error: Failed to stop Docker Compose in $FOLDER_PATH"
    exit 1
fi
