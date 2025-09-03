#!/bin/bash

# Script to connect to HomePi
# Usage: ./connect.sh

# Change the url, username and host if needed
NAME="HomePi"
URL="homepi.local"
USERNAME="homepi"
SSH_HOST="$URL"

# Max attempts to connect to HomePi
ATTEMPTS=0
MAX_ATTEMPTS=10

echo "Connecting to $NAME..."
echo "================================================"
echo "URL: $URL"
echo "Username: $USERNAME"
echo "SSH Host: $SSH_HOST"
echo "================================================"
echo "Checking if host is available..."

while ! ping "$URL" > /dev/null 2>&1; do
    sleep 3
    ATTEMPTS=$((ATTEMPTS + 1))
    if [ $ATTEMPTS -ge $MAX_ATTEMPTS ]; then
        echo "Max attempts reached. Exiting..."
        exit 1
    fi
done

echo "$NAME is up and running!"
echo

echo "Establishing SSH connection..."

# Attempt SSH connection
ssh "$USERNAME@$SSH_HOST"
