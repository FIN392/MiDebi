#!/usr/bin/env bash
set -Eeuo pipefail
trap 'rc=$?; echo "ERROR: \"$BASH_COMMAND\" falló en la línea $LINENO (código de salida: $rc)" >&2; exit "$rc"' ERR

# Instalación de Brave Origin

# Desinstalar
sudo apt purge "brave*" -y || true
sudo apt autoremove -y
rm -rf ~/.config/BraveSoftware/

# Instalar
curl -fsS https://dl.brave.com/install.sh | FLAVOR=origin sh

# Configurar
# ... ~/.config/BraveSoftware

