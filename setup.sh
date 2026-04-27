#!/bin/bash
set -e

echo "========================================="
echo "  VPN Auto-Setup for pv.yasharian.ir"
echo "========================================="

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Run as root${NC}"
    exit 1
fi

# Variables
export UUID="ba360d83-45d0-44d1-b223-f7b26503d184"
export PRIVATE_KEY="kAxMhojriZm912deCi8rrAH9A7lRQnjHpgSyrw-Ty2k"
export PUBLIC_KEY="W5AWCExiWXcFQP13wrnB9IXTsOMoff60HebwLzIW2Vk"
export DOMAIN="pv.yasharian.ir"
export VPS_IP="154.211.2.129"
export EMAIL="admin@yasharian.ir"

# Make scripts executable
chmod +x scripts/*.sh

# Run each step
echo -e "${GREEN}[1/7] Installing system packages...${NC}"
bash scripts/install-packages.sh

echo -e "${GREEN}[2/7] Installing xray core...${NC}"
bash scripts/install-xray.sh

echo -e "${GREEN}[3/7] Setting up website files...${NC}"
bash scripts/setup-website.sh

echo -e "${GREEN}[4/7] Configuring nginx...${NC}"
bash scripts/setup-nginx.sh

echo -e "${GREEN}[5/7] Configuring xray...${NC}"
bash scripts/setup-xray.sh

echo -e "${GREEN}[6/7] Getting SSL certificate...${NC}"
bash scripts/setup-ssl.sh

echo -e "${GREEN}[7/7] Starting services...${NC}"
bash scripts/start-services.sh

# Print client configs
echo ""
echo "========================================="
echo -e "${GREEN}Setup Complete!${NC}"
echo "========================================="
echo ""
echo -e "Nginx: $(systemctl is-active nginx)"
echo -e "Xray:  $(systemctl is-active xray)"
echo ""
echo "Listening ports:"
ss -tlnp | grep -E ':(80|443|8443|10000|10001|10002) ' 2>/dev/null || true
echo ""
echo "========================================="
echo -e "${YELLOW}Client Configs:${NC}"
echo "========================================="
echo ""
echo -e "${GREEN}WebSocket + TLS (Primary):${NC}"
echo "vless://$UUID@$DOMAIN:443?encryption=none&type=ws&path=/api&host=$DOMAIN&security=tls&sni=$DOMAIN#WS-API"
echo ""
echo -e "${GREEN}Reality via tapsi.ir (Backup):${NC}"
echo "vless://$UUID@$VPS_IP:443?encryption=none&flow=xtls-rprx-vision&security=reality&sni=tapsi.ir&fp=chrome&pbk=$PUBLIC_KEY&type=tcp#Tapsi"
echo ""
echo -e "${GREEN}Reality via letsencrypt (Backup 2):${NC}"
echo "vless://$UUID@$VPS_IP:8443?encryption=none&flow=xtls-rprx-vision&security=reality&sni=letsencrypt.org&fp=chrome&pbk=$PUBLIC_KEY&type=tcp#LetsEncrypt"
echo ""
echo -e "${YELLOW}Fake website: https://$DOMAIN${NC}"
echo "========================================="