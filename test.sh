cat > /tmp/test-config.json << 'EOF'
{
  "log": {"loglevel": "debug"},
  "inbounds": [{
    "port": 10000,
    "listen": "127.0.0.1",
    "protocol": "vless",
    "settings": {
      "clients": [{"id": "ba360d83-45d0-44d1-b223-f7b26503d184"}],
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

/usr/local/bin/xray run -test -c /tmp/test-config.json
/usr/local/bin/xray run -c /tmp/test-config.json &
sleep 2
curl -v http://127.0.0.1:10000/api