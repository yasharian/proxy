#!/bin/bash
set -e

echo "Creating directory structure..."
mkdir -p /var/www/html/pages
mkdir -p /var/www/html/assets
mkdir -p /var/www/html/api

echo "Copying main pages..."
cp configs/tapsi.html /var/www/html/tapsi.html
cp configs/tapsi-app.html /var/www/html/tapsi-app.html
cp configs/tapsi-api.html /var/www/html/api/index.html
cp configs/tapsi.html /var/www/html/index.html

echo "Copying sub-pages..."
cp pages/faq.html /var/www/html/pages/faq.html
cp pages/contact.html /var/www/html/pages/contact.html
cp pages/driver.html /var/www/html/pages/driver.html

echo "Copying assets..."
cp assets/style.css /var/www/html/assets/style.css 2>/dev/null || true

echo "Setting permissions..."
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

echo "Website files installed."