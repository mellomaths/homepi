#!/bin/bash

# Get the current directory (should be apps/nginx)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$SCRIPT_DIR/config"

echo "Applying nginx configuration from $CONFIG_DIR"

# Remove sites directories
sudo rm -rf /etc/nginx/sites-enabled
sudo rm -rf /etc/nginx/sites-available

# Create directories if they don't exist
sudo mkdir -p /etc/nginx/sites-available
sudo mkdir -p /etc/nginx/sites-enabled

# Copy nginx.conf to /etc/nginx/
echo "Copying nginx.conf..."
sudo cp "$CONFIG_DIR/nginx.conf" /etc/nginx/nginx.conf

# Copy sites-available configurations
echo "Copying site configurations..."
sudo cp "$CONFIG_DIR/sites-available/"* /etc/nginx/sites-available/

# Remove old symlinks and create new ones
echo "Creating symlinks..."
sudo ln -sf /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/
sudo ln -sf /etc/nginx/sites-available/glance.conf /etc/nginx/sites-enabled/
sudo ln -sf /etc/nginx/sites-available/pihole.conf /etc/nginx/sites-enabled/
sudo ln -sf /etc/nginx/sites-available/portainer.conf /etc/nginx/sites-enabled/
sudo ln -sf /etc/nginx/sites-available/cockpit.conf /etc/nginx/sites-enabled/

echo "=== Nginx Configuration Test ==="
echo

# Check if nginx is installed
if ! command -v nginx &> /dev/null; then
    echo "❌ nginx is not installed"
    exit 1
fi

echo "✅ nginx is installed"

# Check current nginx config
echo
echo "=== Current nginx.conf ==="
if [ -f /etc/nginx/nginx.conf ]; then
    echo "✅ /etc/nginx/nginx.conf exists"
    echo "First few lines:"
    head -5 /etc/nginx/nginx.conf
else
    echo "❌ /etc/nginx/nginx.conf does not exist"
fi

# Check sites-enabled directory
echo
echo "=== Sites-enabled directory ==="
if [ -d /etc/nginx/sites-enabled ]; then
    echo "✅ /etc/nginx/sites-enabled exists"
    echo "Contents:"
    ls -la /etc/nginx/sites-enabled/
else
    echo "❌ /etc/nginx/sites-enabled does not exist"
fi

# Check sites-available directory
echo
echo "=== Sites-available directory ==="
if [ -d /etc/nginx/sites-available ]; then
    echo "✅ /etc/nginx/sites-available exists"
    echo "Contents:"
    ls -la /etc/nginx/sites-available/
else
    echo "❌ /etc/nginx/sites-available does not exist"
fi

# Test nginx configuration
echo
echo "=== Testing nginx configuration ==="
sudo nginx -t 2>&1

if [ $? -eq 0 ]; then
    echo "Nginx configuration is valid."
    
    # Check if nginx is running
    if systemctl is-active --quiet nginx; then
        echo "Reloading nginx..."
        sudo systemctl reload nginx
    else
        echo "Starting nginx service..."
        sudo systemctl start nginx
        sudo systemctl enable nginx
    fi
    
    echo "Sites enabled successfully!"
    echo "Available sites:"
    echo "  - http://homepi.net (main dashboard)"
    echo "  - http://pihole.homepi.net (pihole)"
    echo "  - http://glance.homepi.net (glance)"
    echo "  - http://portainer.homepi.net (portainer)"
    echo "  - http://cockpit.homepi.net (cockpit)"
    # Show nginx status
    echo
    echo "Nginx status:"
    sudo systemctl status nginx --no-pager -l
else
    echo "Nginx configuration has errors. Please fix them first."
    exit 1
fi
