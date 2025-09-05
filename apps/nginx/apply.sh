# Copy /config/nginx.conf to /etc/nginx/
sudo cp ./config/nginx.conf /etc/nginx/nginx.conf
# sudo cp ./nginx/config/nginx.conf /etc/nginx/sites-available/default

# Reload nginx
sudo systemctl reload nginx
