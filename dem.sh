#!/bin/bash
# GET ALL USER INPUT
echo "Domain Name (eg. example.com)?"
read DOMAIN

echo "Updating OS................."
sudo apt-get update

echo "Sit back and relax :) ......"
cd /etc/nginx/sites-available/
wget -O "$DOMAIN" https://goo.gl/s8pdtv
sed -i -e "s/example.com/$DOMAIN/" "$DOMAIN"
sed -i -e "s/www.example.com/www.$DOMAIN/" "$DOMAIN"
echo "Setting up Wordpress With Cloudflare FULL SSL"
sleep 2;
sudo mkdir /var/www/"$DOMAIN"
cd /var/www/"$DOMAIN"
sudo su -c 'echo "<?php phpinfo(); ?>" |tee info.php'
cd ~
wget wordpress.org/latest.zip
unzip latest.zip
mv /root/wordpress/* /var/www/"$DOMAIN"/
rm -rf wordpress latest.zip

echo "Nginx server installation completed"
sleep 2;
cd ~
sudo chown www-data:www-data -R /var/www/"$DOMAIN"
sudo systemctl restart nginx.service
