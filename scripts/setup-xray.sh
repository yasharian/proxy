#!/bin/bash
set -e

echo "Copying xray config..."
mkdir -p /usr/local/etc/xray
cp configs/xray-config.json /usr/local/etc/xray/config.json

echo "Xray configured."