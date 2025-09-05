#!/bin/bash

# Check if a parameter is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <folder_name>"
    echo "Example: $0 dashboards/glance"
    exit 1
fi

# Get the folder path from the first parameter
APPLICATION="$1"
FOLDER_PATH=""

# Check if the application is valid
if [ "$APPLICATION" == "glance" ]; then
    FOLDER_PATH="dashboards/glance"
fi

if [ "$APPLICATION" == "portainer" ]; then
    FOLDER_PATH="dashboards/portainer"
fi

if [ "$APPLICATION" == "nginx" ]; then
    FOLDER_PATH="nginx"
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

# Check if install.sh exists in the folder
if [ ! -f "$FOLDER_PATH/install.sh" ]; then
    echo "Error: install.sh not found in '$FOLDER_PATH'"
    exit 1
fi

echo "Installing $APPLICATION"

# Navigate to the folder and run docker compose up -d
cd "$FOLDER_PATH" && ./install.sh

# Check if the command was successful
if [ $? -eq 0 ]; then
    echo "Installed successfully $APPLICATION"
else
    echo "Error: Failed to install $APPLICATION"
    exit 1
fi
