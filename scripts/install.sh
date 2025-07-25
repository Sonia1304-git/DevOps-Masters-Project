#!/bin/bash
set -xe

echo "Running install.sh script..."

# Install and start Apache
sudo yum install -y httpd
sudo systemctl enable httpd
sudo systemctl restart httpd

# Create the destination directory if it doesn't exist
sudo mkdir -p /var/www/html

# Move all contents (your index.html etc.) to the web root
sudo cp -r * /var/www/html/

# Set permissions
sudo chmod -R 755 /var/www/html

echo "Deployment finished successfully."