# Copy /config/nginx.conf to /etc/nginx/sites-available/default
sudo cp /config/nginx.conf /etc/nginx/sites-available/default

# Reload nginx
sudo systemctl reload nginx
