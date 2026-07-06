#!/usr/bin/env bash
set -e

SERVER_IP="YOUR_SERVER_IP"
CONN_NAME="$(nmcli -t -f NAME,DEVICE connection show --active | awk -F: '$2 ~ /^wl/ {print $1; exit}')"
XRAY_UID="$(ps -o uid= -C xray | awk 'NF{print $1; exit}')"

sudo systemctl restart xray
sudo systemctl restart redsocks

sleep 1

sudo iptables -t nat -D OUTPUT -p tcp -j XRAYTCP 2>/dev/null || true
sudo iptables -t nat -F XRAYTCP 2>/dev/null || true
sudo iptables -t nat -X XRAYTCP 2>/dev/null || true

sudo iptables -t nat -N XRAYTCP
sudo iptables -t nat -A XRAYTCP -o lo -j RETURN

if [ -n "$XRAY_UID" ]; then
  sudo iptables -t nat -A XRAYTCP -m owner --uid-owner "$XRAY_UID" -j RETURN
fi

sudo iptables -t nat -A XRAYTCP -p tcp -d "$SERVER_IP" --dport 443 -j RETURN
sudo iptables -t nat -A XRAYTCP -p tcp --dport 12345 -j RETURN
sudo iptables -t nat -A XRAYTCP -p tcp --dport 10808 -j RETURN

sudo iptables -t nat -A XRAYTCP -d 10.0.0.0/8 -j RETURN
sudo iptables -t nat -A XRAYTCP -d 192.168.0.0/16 -j RETURN

sudo iptables -t nat -A XRAYTCP -p tcp -j REDIRECT --to-ports 12345
sudo iptables -t nat -A OUTPUT -p tcp -j XRAYTCP

if [ -n "$CONN_NAME" ]; then
  sudo nmcli connection modify "$CONN_NAME" ipv4.ignore-auto-dns yes
  sudo nmcli connection modify "$CONN_NAME" ipv4.dns "1.1.1.1 1.0.0.1"
  sudo nmcli connection up "$CONN_NAME"
fi

echo "VPN ON"
curl -s https://api.ipify.org
echo
