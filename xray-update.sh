#!/bin/bash

URL="YOURSUBSCRIPTIONLINK"

TMP=$(mktemp)

echo "[+] Downloading config..."
curl -s "$URL" > "$TMP"

echo "[+] Extracting parameters..."

SERVER=$(grep -m1 '"server":' "$TMP" | head -1 | cut -d '"' -f4)
UUID=$(grep -m1 '"uuid":' "$TMP" | head -1 | cut -d '"' -f4)
SNI=$(grep -m1 '"server_name":' "$TMP" | head -1 | cut -d '"' -f4)
SERVICE=$(grep -m1 '"service_name":' "$TMP" | head -1 | cut -d '"' -f4)

echo "[+] Building config..."

sudo tee /etc/xray/config.json > /dev/null <<EOF
{
  "log": {
    "loglevel": "warning"
  },
  "inbounds": [
    {
      "port": 10808,
      "listen": "127.0.0.1",
      "protocol": "socks",
      "settings": {
        "udp": true
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "vless",
      "settings": {
        "vnext": [
          {
            "address": "$SERVER",
            "port": 443,
            "users": [
              {
                "id": "$UUID",
                "encryption": "none"
              }
            ]
          }
        ]
      },
      "streamSettings": {
        "network": "grpc",
        "security": "tls",
        "tlsSettings": {
          "serverName": "$SNI",
          "allowInsecure": true
        },
        "grpcSettings": {
          "serviceName": "$SERVICE"
        }
      }
    }
  ]
}
EOF

echo "[+] Restarting Xray..."
sudo systemctl restart xray

echo "[✓] Done!"
