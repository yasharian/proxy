cat > /usr/local/etc/xray/config.json << 'EOF'
{
  "log": {
    "loglevel": "warning"
  },
  "inbounds": [
    {
      "tag": "REALITY_IN",
      "port": 443,
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "b3f7d18f-6a8f-4d6e-8d78-823c5511906c",
            "flow": "xtls-rprx-vision"
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "tcp",
        "security": "reality",
        "realitySettings": {
          "show": false,
          "dest": "<your_chosen_domain>:443",
          "serverNames": ["<your_chosen_domain>"],
          "privateKey": "0P32Y_rh2gYqFyU3c_CPZ61PVq6UmBNQVqwPevJX-U0",
          "shortIds": ["", "6ba7b810-9dad-11d1-80b4-00c04fd430c8"],
          "fingerprint": "chrome",
          "xver": 0
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": ["http", "tls"]
      }
    },
    {
      "tag": "SOCKS_IN",
      "port": 1080,
      "protocol": "socks",
      "settings": {
        "auth": "noauth",
        "udp": true,
        "ip": "127.0.0.1"
      },
      "sniffing": {
        "enabled": true,
        "destOverride": ["http", "tls"]
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "tag": "direct"
    },
    {
      "protocol": "blackhole",
      "tag": "block"
    }
  ]
}
EOF

pkill xray
systemctl stop xray 2>/dev/null

# Run directly with config
/usr/local/bin/xray run -c /usr/local/etc/xray/config.json &
echo waiting 3s until make sure it set up
sleep 1
echo  waiting 2s until make sure it set up
sleep 1
echo  waiting 1s until make sure it set up
sleep 1

ss -tlnp | grep -E ':80|:443'