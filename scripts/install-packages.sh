#!/bin/bash
set -e

echo "Updating system..."
apt update && apt upgrade -y

echo "Installing packages..."
apt install -y nginx certbot python3-certbot-nginx unzip wget curl