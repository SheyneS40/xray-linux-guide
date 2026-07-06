#!/usr/bin/env bash
set -e

CONN_NAME="$(nmcli -t -f NAME,DEVICE connection show --active | awk -F: '$2 ~ /^wl/ {print $1; exit}')"

sudo iptables -t nat -D OUTPUT -p tcp -j XRAYTCP 2>/dev/null || true
sudo iptables -t nat -F XRAYTCP 2>/dev/null || true
sudo iptables -t nat -X XRAYTCP 2>/dev/null || true

if [ -n "$CONN_NAME" ]; then
  sudo nmcli connection modify "$CONN_NAME" ipv4.ignore-auto-dns no
  sudo nmcli connection modify "$CONN_NAME" ipv4.dns ""
  sudo nmcli connection up "$CONN_NAME"
fi

sudo systemctl stop redsocks
sudo systemctl stop xray

echo "VPN OFF"
curl -s https://api.ipify.org
echo
