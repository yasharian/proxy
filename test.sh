cat > /usr/local/etc/xray/config.json << 'EOF'
{
  "log": {"loglevel": "warning"},
  "inbounds": [
    {
      "tag": "ws-direct",
      "port": 80,
      "protocol": "vless",
      "settings": {
        "clients": [{"id": "ba360d83-45d0-44d1-b223-f7b26503d184", "flow": ""}],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {"path": "/api"}
      },
      "sniffing": {"enabled": true, "destOverride": ["http", "tls"]}
    },
    {
      "tag": "reality-tapsi",
      "port": 443,
      "protocol": "vless",
      "settings": {
        "clients": [{"id": "ba360d83-45d0-44d1-b223-f7b26503d184", "flow": "xtls-rprx-vision"}],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "tcp",
        "security": "reality",
        "realitySettings": {
          "show": false,
          "dest": "tapsi.ir:443",
          "xver": 0,
          "serverNames": ["tapsi.ir", "snapp.ir", "liara.ir"],
          "privateKey": "kAxMhojriZm912deCi8rrAH9A7lRQnjHpgSyrw-Ty2k",
          "shortIds": [""]
        }
      },
      "sniffing": {"enabled": true, "destOverride": ["http", "tls"]}
    }
  ],
  "outbounds": [{"protocol": "freedom"}]
}
EOF

systemctl restart xray
systemctl status xray

ss -tlnp | grep -E ':80|:443'