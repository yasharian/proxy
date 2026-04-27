#!/bin/bash
set -e

echo "Backing up existing nginx config..."
cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bak 2>/dev/null || true

echo "Copying nginx config..."
cp configs/nginx-default /etc/nginx/sites-available/default

echo "Testing nginx configuration..."
nginx -t

echo "Nginx configured."