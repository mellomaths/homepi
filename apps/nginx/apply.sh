# Copy /config/nginx.conf to /etc/nginx/sites-available/default
sudo cp ./nginx/config/nginx.conf /etc/nginx/sites-available/default

# Reload nginx
sudo systemctl reload nginx
