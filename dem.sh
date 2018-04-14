#!/bin/bash
# GET ALL USER INPUT
echo "Domain Name (eg. example.com)?"
read DOMAIN

echo "Updating OS................."
sudo apt-get update

echo "Installing Nginx"
sudo apt-get install nginx -y

echo "Sit back and relax :) ......"
cd /etc/nginx/sites-available/
wget -O "$DOMAIN" https://goo.gl/s8pdtv
sed -i -e "s/example.com/$DOMAIN/" "$DOMAIN"
sed -i -e "s/www.example.com/www.$DOMAIN/" "$DOMAIN"
echo "Setting up Cloudflare FULL SSL"
sudo mkdir /etc/nginx/ssl
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt
sudo openssl dhparam -out /etc/nginx/ssl/dhparam.pem 2048
cd /etc/nginx/
sudo mv nginx.conf nginx.conf.backup
wget -O nginx.conf https://goo.gl/n8crcR
sudo mkdir /var/www/"$DOMAIN"
cd /var/www/"$DOMAIN"
sudo su -c 'echo "<?php phpinfo(); ?>" |tee info.php'
echo "Nginx server installation completed"
cd ~
sudo systemctl restart nginx.service

echo "lets install php 7.0"
sudo apt install php7.0 php7.0-fpm
sudo apt-get -y install php7.0-fpm php7.0-curl php7.0-gd php7.0-imap php7.0-mcrypt php7.0-readline php7.0-common php7.0-recode php7.0-mysql php7.0-cli php7.0-curl php7.0-mbstring php7.0-bcmath php7.0-mysql php7.0-opcache php7.0-zip php7.0-xml php-memcached php-imagick php-memcache memcached graphviz php-pear php-xdebug php-msgpack  php7.0-soap
sudo systemctl restart php7.0-fpm.service
sudo apt install mariadb-server mariadb-client php7.0-mysql
sudo systemctl restart php7.0-fpm.service

echo "Instaling MariaDB"
sudo mysql_secure_installation
