#!/bin/bash
set -e

echo "Enabling services..."
systemctl enable nginx
systemctl enable xray

echo "Starting nginx..."
systemctl restart nginx

echo "Starting xray..."
systemctl restart xray

echo "Configuring firewall..."
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 8443/tcp
ufw --force enable

echo "Setting up SSL auto-renewal..."
(crontab -l 2>/dev/null; echo "0 3 * * * certbot renew --quiet && systemctl reload nginx") | crontab -

echo ""
echo "Services started:"
echo "  Nginx: $(systemctl is-active nginx)"
echo "  Xray:  $(systemctl is-active xray)"