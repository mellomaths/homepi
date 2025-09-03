#!/bin/bash

# Script to connect to HomePi
# Usage: ./connect.sh

URL="homepi.local"
USERNAME="homepi"
SSH_HOST="$URL"

# Max attempts to connect to HomePi
ATTEMPTS=0
MAX_ATTEMPTS=10

echo "================================================"
echo "Connecting to HomePi..."
echo "Attempting to connect to HomePi at '$URL'..."

while ! ping "$URL" > /dev/null 2>&1; do
    sleep 3
    ATTEMPTS=$((ATTEMPTS + 1))
    if [ $ATTEMPTS -ge $MAX_ATTEMPTS ]; then
        echo "Max attempts reached. Exiting..."
        exit 1
    fi
done

echo "HomePi is up and running!"

echo "Establishing SSH connection to HomePi..."

echo "Connecting to $USERNAME@$SSH_HOST..."

# Attempt SSH connection
ssh "$USERNAME@$SSH_HOST"
