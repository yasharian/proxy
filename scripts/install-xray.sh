#!/bin/bash
set -e

if command -v xray &>/dev/null; then
    echo "xray already installed"
    exit 0
fi

echo "Installing xray..."

# Try official script
if bash -c "$(curl -Ls https://raw.githubusercontent.com/XTLS/Xray-install/main/install-release.sh)"; then
    echo "xray installed via official script"
    exit 0
fi

# Fallback: manual install
echo "Official script failed, installing manually..."
XRAY_VERSION=$(curl -s https://api.github.com/repos/XTLS/Xray-core/releases/latest | grep tag_name | cut -d '"' -f 4)
ARCH=$(uname -m)

case $ARCH in
    x86_64)  XRAY_ARCH="linux-64" ;;
    aarch64) XRAY_ARCH="linux-arm64-v8a" ;;
    *) echo "Unsupported arch: $ARCH"; exit 1 ;;
esac

wget "https://github.com/XTLS/Xray-core/releases/download/${XRAY_VERSION}/Xray-${XRAY_ARCH}.zip" -O /tmp/xray.zip
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