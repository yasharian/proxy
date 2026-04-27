#!/bin/bash
set -e

DOMAIN="$1"
EMAIL="$2"

if [ -z "$DOMAIN" ]; then
    echo "Usage: $0 <domain> <email>"
    exit 1
fi

# Install certbot
apt install -y certbot python3-certbot-nginx

# Stop nginx temporarily
systemctl stop nginx 2>/dev/null || true

# Get certificate
if certbot certonly --standalone -d "$DOMAIN" --non-interactive --agree-tos --email "$EMAIL"; then
    echo "SSL obtained successfully"
else
    echo "Standalone failed, trying webroot..."
    systemctl start nginx
    certbot certonly --webroot -w /var/www/html -d "$DOMAIN" --non-interactive --agree-tos --email "$EMAIL"
fi

# Start nginx
systemctl start nginx