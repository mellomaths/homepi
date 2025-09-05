# Copy /config/nginx.conf to /etc/nginx/
sudo cp ./config/nginx.conf /etc/nginx/nginx.conf

# Copy /config/sites-available to /etc/nginx/sites-available/
sudo cp ./config/sites-available/* /etc/nginx/sites-available/

# Enable all sites by creating symlinks
sudo ln -sf ./etc/nginx/sites-available/homepi.conf /etc/nginx/sites-enabled/homepi.conf
sudo ln -sf ./etc/nginx/sites-available/glance.conf /etc/nginx/sites-enabled/glance.conf
sudo ln -sf ./etc/nginx/sites-available/portainer.conf /etc/nginx/sites-enabled/portainer.conf
sudo ln -sf ./etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf

# Test nginx configuration
sudo nginx -t

if [ $? -eq 0 ]; then
    echo "Nginx configuration is valid. Reloading..."
    sudo systemctl reload nginx
    echo "Sites enabled successfully!"
else
    echo "Nginx configuration has errors. Please fix them first."
    exit 1
fi

# Reload nginx
sudo systemctl reload nginx
