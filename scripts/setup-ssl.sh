#!/bin/bash
set -e

DOMAIN="${DOMAIN:-pv.yasharian.ir}"
EMAIL="${EMAIL:-admin@yasharian.ir}"

echo "Stopping nginx for SSL setup..."
systemctl stop nginx 2>/dev/null || true

echo "Requesting SSL certificate for $DOMAIN..."
if certbot certonly --standalone -d "$DOMAIN" --non-interactive --agree-tos --email "$EMAIL"; then
    echo "SSL certificate obtained successfully."
else
    echo "Standalone failed. Trying webroot method..."
    systemctl start nginx
    certbot certonly --webroot -w /var/www/html -d "$DOMAIN" --non-interactive --agree-tos --email "$EMAIL"
fi

echo "SSL setup complete."