#!/usr/bin/env bash
set -Eeuo pipefail
trap 'rc=$?; echo "ERROR: \"$BASH_COMMAND\" falló en la línea $LINENO (código de salida: $rc)" >&2; exit "$rc"' ERR

# Instalación de Brave Origin
DIR_ACTUAL="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Desinstalar
sudo apt purge "brave*" -y || true
sudo apt autoremove -y
rm -rf ~/.config/BraveSoftware/

# Instalar
curl -fsS https://dl.brave.com/install.sh | FLAVOR=origin sh

# Configurar
# tar -czvf "$HOME/BraveSoftware.tar.gz" -C "$HOME/.config" BraveSoftware
tar -xzvf "$DIR_ACTUAL/BraveSoftware.tar.gz" -C "$HOME/.config"
