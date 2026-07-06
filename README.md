# xray-linux-guide
Xray VPN on Linux (No GUI)
Simple and reliable way to run Xray VPN on Linux without Hiddify or GUI clients.

---

Русская версия

Возможности
- Работает на Ubuntu / Mint / Arch / Manjaro
- Без GUI-клиентов
- Прозрачный VPN (весь трафик уходит через туннель)
- Быстрое включение/выключение

---

Установка Xray:
bash <(curl -Ls https://github.com/XTLS/Xray-install/raw/main/install-release.sh)

Настройка.

Файл:
/usr/local/etc/xray/config.json
Вставьте конфиг из вашей подписки (VLESS / VMess и т.д.)

Запуск:
sudo systemctl enable --now xray

Redsocks:
sudo apt install redsocks
или
sudo pacman -S redsocks

Быстрое включение VPN.
Создать файл:
nano ~/vpn-on.sh
(вставьте содержимое из инструкции)

Выключение VPN:
nano ~/vpn-off.sh
(вставьте содержимое из инструкции)

Права:
chmod +x ~/vpn-on.sh ~/vpn-off.sh

Использование:
~/vpn-on.sh
~/vpn-off.sh

Проверка:
curl https://api.ipify.org

Примечания:
- UDP требует дополнительной настройки (TPROXY)
- IPv6 рекомендуется отключить
- Подписка обновляется вручную или через скрипт

===================================================================================

English version

Features
- Works on Ubuntu / Mint / Arch / Manjaro
- No GUI clients required
- Transparent VPN (all traffic goes through tunnel)
- Quick ON/OFF scripts

---

Install Xray:
bash <(curl -Ls https://github.com/XTLS/Xray-install/raw/main/install-release.sh)

Configuration.
File:
/usr/local/etc/xray/config.json
Insert your subscription config (VLESS / VMess etc.)

Start:
sudo systemctl enable --now xray

Redsocks:
sudo apt install redsocks
or
sudo pacman -S redsocks

Quick VPN ON.

Create:
nano ~/vpn-on.sh

Quick VPN OFF:
nano ~/vpn-off.sh

Make executable:
chmod +x ~/vpn-on.sh ~/vpn-off.sh

Usage:
./vpn-on.sh
./vpn-off.sh

Check IP:
curl https://api.ipify.org

Notes
- TCP only (UDP requires extra setup)
- IPv6 should be disabled
- Config can be auto-updated via subscription script
