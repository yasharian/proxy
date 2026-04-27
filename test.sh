cat > /usr/local/etc/xray/config.json << 'EOF'
{
  "log": {"loglevel": "warning"},
  "inbounds": [{
    "tag": "cdn-ws",
    "port": 443,
    "protocol": "vless",
    "settings": {
      "clients": [{"id": "ba360d83-45d0-44d1-b223-f7b26503d184", "flow": ""}],
      "decryption": "none"
    },
    "streamSettings": {
      "network": "ws",
      "wsSettings": {"path": "/api"}
    }
  }],
  "outbounds": [{"protocol": "freedom"}]
}
EOF

pkill xray
systemctl stop xray 2>/dev/null

# Run directly with config
/usr/local/bin/xray run -c /usr/local/etc/xray/config.json
echo waiting 3s until make sure it set up
sleep 1
echo  waiting 2s until make sure it set up
sleep 1
echo  waiting 1s until make sure it set up
sleep 1

ss -tlnp | grep -E ':80|:443'