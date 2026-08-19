#!/usr/bin/env bash
set -Eeuo pipefail
trap 'rc=$?; echo "ERROR: \"$BASH_COMMAND\" falló en la línea $LINENO (código de salida: $rc)" >&2; exit "$rc"' ERR

# Instalación de ......

# Desinstalar
sudo apt purge ...... -y
sudo apt autoremove -y

# Instalar
sudo apt install ...... -y

# Configurar
# ......

