#!/usr/bin/env bash
set -Eeuo pipefail
trap 'rc=$?; echo "ERROR: \"$BASH_COMMAND\" falló en la línea $LINENO (código de salida: $rc)" >&2; exit "$rc"' ERR

# Instalación de Tiling Shell

# Instalar
curl -L -o /tmp/tilingshell.zip "https://extensions.gnome.org/download-extension/tilingshell@ferrarodomenico.com.shell-extension.zip?version_tag=70233"
gnome-extensions install --force /tmp/tilingshell.zip
gnome-extensions enable tilingshell@ferrarodomenico.com
rm --force /tmp/tilingshell.zip

#
