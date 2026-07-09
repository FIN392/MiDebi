#!/usr/bin/env bash
set -Eeuo pipefail
trap 'rc=$?; echo "ERROR: \"$BASH_COMMAND\" falló en la línea $LINENO (código de salida: $rc)" >&2; exit "$rc"' ERR

# Instalación de Snapper

# Desinstalar
# sudo apt purge ...* -y
# sudo rm --force --recursive /usr/lib/firefox-esr
# sudo rm --force --recursive /usr/share/firefox-esr
# rm --force --recursive ~/.mozilla/firefox
# rm --force --recursive ~/.cache/mozilla/firefox

# Instalar
# sudo apt install ... y

# Configurar
# ...
