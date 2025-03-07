#!/bin/bash
# userdata.sh - Enhanced Setup script for WebServer

# Debug shit
sudo logger "userdata-script-start"

# Update OS
yum update -y

# Install PHP
amazon-linux-extras enable php8.0
yum install -y httpd php php-cli php-mbstring php-xml php-json curl lynx nc htop

# Enable httpd
systemctl enable httpd

# Configure Apache to accept connections on port 80 without SSL
sed -i 's/DirectoryIndex index.html/DirectoryIndex index.php index.html/' /etc/httpd/conf/httpd.conf

# Now we process the files from the html dirctory. Terraform copied them over
sudo mv /tmp/html/* /var/www/html/.

# Restart Apache to apply changes
systemctl start httpd

# Create user alchaney with home directory and set full name
useradd -m -c "Alex Chaney" alchaney

# Add alchaney to sudoers
echo "alchaney ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Debug shit
sudo logger "userdata-script-complete"
