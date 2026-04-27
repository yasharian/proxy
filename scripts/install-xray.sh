#!/bin/bash
set -e

if command -v xray &>/dev/null; then
    echo "xray already installed: $(xray version | head -1)"
    exit 0
fi

echo "Installing xray core..."

# Try official install script
if bash -c "$(curl -Ls https://raw.githubusercontent.com/XTLS/Xray-install/main/install-release.sh)"; then
    echo "xray installed via official script"
    exit 0
fi

# Mirror fallback
if bash -c "$(curl -Ls https://ghproxy.com/https://raw.githubusercontent.com/XTLS/Xray-install/main/install-release.sh)"; then
    echo "xray installed via mirror"
    exit 0
fi

# Manual install fallback
echo "Script installs failed — manual install..."
XRAY_VERSION=$(curl -s https://api.github.com/repos/XTLS/Xray-core/releases/latest | grep tag_name | cut -d '"' -f 4)
wget "https://github.com/XTLS/Xray-core/releases/download/${XRAY_VERSION}/Xray-linux-64.zip" -O /tmp/xray.zip
unzip -o /tmp/xray.zip -d /usr/local/bin/
chmod +x /usr/local/bin/xray

# Create systemd service
cat > /etc/systemd/system/xray.service << 'EOF'
[Unit]
Description=Xray Service
After=network.target

[Service]
ExecStart=/usr/local/bin/xray run -c /usr/local/etc/xray/config.json
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

mkdir -p /usr/local/etc/xray
systemctl daemon-reload
echo "xray installed manually"