#!/usr/bin/env bash
set -Eeuo pipefail
trap 'rc=$?; echo "ERROR: \"$BASH_COMMAND\" falló en la línea $LINENO (código de salida: $rc)" >&2; exit "$rc"' ERR

# Instalación de fastfetch

# Desinstalar
sudo apt purge "fastfetch*" -y || true
sudo apt autoremove -y
rm -R ~/.config/fastfetch/

# Instalar
sudo apt install fastfetch -y

# Configurar
fastfetch --gen-config
cp fastfetch.config.config.jsonc ~/.config/fastfetch/config.jsonc

