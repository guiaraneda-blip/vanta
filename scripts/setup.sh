#!/bin/bash
# Vanta OS — Setup Script
# by GA
# Este script instala y configura el entorno base de Vanta OS.
# > En desarrollo — no ejecutar todavia.

echo "================================"
echo "  VANTA OS — Setup v0.1.0"
echo "  by GA"
echo "================================"

# Actualizar sistema
# apt update && apt upgrade -y

# Instalar dependencias base
# apt install -y nmap masscan whois dig theharvester \
#               metasploit-framework burpsuite sqlmap \
#               netcat john hashcat

# Instalar SPECTR
# git clone https://github.com/guiaraneda-blip/spectr.git /opt/spectr
# cd /opt/spectr && pip install -r requirements.txt
# ln -s /opt/spectr/spectr.py /usr/local/bin/spectr

# Aplicar branding
# cp branding/wallpapers/vanta-wallpaper.png /usr/share/backgrounds/
# cp branding/bootscreen/vanta-plymouth /usr/share/plymouth/themes/

echo "Vanta OS setup complete."
echo "Lo ve todo. No lo ve nadie."
