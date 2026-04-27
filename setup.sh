#!/bin/bash
set -e

echo "========================================="
echo "  VPN Auto-Setup for pv.yasharian.ir"
echo "========================================="

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Check root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Run as root${NC}"
    exit 1
fi

# Variables
UUID="ba360d83-45d0-44d1-b223-f7b26503d184"       # CHANGE THIS
PRIVATE_KEY="kAxMhojriZm912deCi8rrAH9A7lRQnjHpgSyrw-Ty2k"  # CHANGE THIS
PUBLIC_KEY="W5AWCExiWXcFQP13wrnB9IXTsOMoff60HebwLzIW2Vk"   # CHANGE THIS
DOMAIN="pv.yasharian.ir"
VPS_IP="154.211.2.129"
EMAIL="admin@yasharian.ir"

echo -e "${GREEN}[1/7] Updating system...${NC}"
apt update && apt upgrade -y

echo -e "${GREEN}[2/7] Installing packages...${NC}"
apt install -y nginx unzip wget curl

echo -e "${GREEN}[3/7] Installing xray...${NC}"
bash scripts/install-xray.sh

echo -e "${GREEN}[4/7] Copying configs...${NC}"
# xray config
mkdir -p /usr/local/etc/xray
sed -e "s/YOUR_UUID/$UUID/g" \
    -e "s/YOUR_PRIVATE_KEY/$PRIVATE_KEY/g" \
    configs/xray-config.json > /usr/local/etc/xray/config.json

# nginx config
cp configs/nginx-default /etc/nginx/sites-available/default

# website
cp configs/index.html /var/www/html/index.html

echo -e "${GREEN}[5/7] Getting SSL certificate...${NC}"
bash scripts/get-ssl.sh "$DOMAIN" "$EMAIL"

echo -e "${GREEN}[6/7] Setting permissions...${NC}"
chown -R www-data:www-data /var/www/html
nginx -t

echo -e "${GREEN}[7/7] Starting services...${NC}"
systemctl restart nginx
systemctl restart xray
systemctl enable nginx xray

# Firewall
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 22/tcp
ufw --force enable

# Auto-renew SSL
echo "0 3 * * * certbot renew --quiet && systemctl reload nginx" | crontab -

echo ""
echo "========================================="
echo -e "${GREEN}Setup Complete!${NC}"
echo "========================================="
echo ""
echo "Client config (WebSocket):"
echo "Address: $DOMAIN"
echo "Port: 443"
echo "UUID: $UUID"
echo "Network: ws"
echo "Path: /api"
echo "Host: $DOMAIN"
echo "TLS: ON"
echo ""
echo "vless link:"
echo "vless://$UUID@$DOMAIN:443?encryption=none&type=ws&path=/api&host=$DOMAIN&security=tls&sni=$DOMAIN#Amsterdam-WS"
echo ""
echo "========================================="

echo -e "${GREEN}[4/7] Copying website files...${NC}"

# Create directory structure
mkdir -p /var/www/html/pages /var/www/html/assets /var/www/html/api

# Main pages
cp configs/tapsi.html /var/www/html/tapsi.html
cp configs/tapsi-app.html /var/www/html/tapsi-app.html
cp configs/tapsi-api.html /var/www/html/api/index.html
cp configs/index.html /var/www/html/index.html

# Sub-pages
cp pages/faq.html /var/www/html/pages/faq.html
cp pages/contact.html /var/www/html/pages/contact.html
cp pages/driver.html /var/www/html/pages/driver.html

# Assets
cp assets/style.css /var/www/html/assets/style.css

# Set nginx as default index
ln -sf /var/www/html/tapsi.html /var/www/html/index.html 2>/dev/null || true

# Permissions
chown -R www-data:www-data /var/www/html