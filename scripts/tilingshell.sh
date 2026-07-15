#!/usr/bin/env bash
set -Eeuo pipefail
trap 'rc=$?; echo "ERROR: \"$BASH_COMMAND\" falló en la línea $LINENO (código de salida: $rc)" >&2; exit "$rc"' ERR

# Instalación de Tiling Shell

# Instalar
EXTENSION_ID="tilingshell@ferrarodomenico.com"
INSTALL_DIR="$HOME/.local/share/gnome-shell/extensions/$EXTENSION_ID"
curl -L -o /tmp/tilingshell.zip "https://extensions.gnome.org/download-extension/${EXTENSION_ID}.shell-extension.zip?version_tag=70233"
mkdir -p "$INSTALL_DIR"
tar -xf /tmp/tilingshell.zip -C "$INSTALL_DIR"
rm --force /tmp/tilingshell.zip
CURRENT_EXTENSIONS=$(gsettings get org.gnome.shell enabled-extensions)
if [[ "$CURRENT_EXTENSIONS" == *"$EXTENSION_ID"* ]]; then
    echo "La extensión ya estaba habilitada en el sistema."
else
    if [ "$CURRENT_EXTENSIONS" = "@as []" ] || [ "$CURRENT_EXTENSIONS" = "[]" ] || [ -z "$CURRENT_EXTENSIONS" ]; then
        NEW_EXTENSIONS="['$EXTENSION_ID']"
    else
        NEW_EXTENSIONS="${CURRENT_EXTENSIONS%]*}, '$EXTENSION_ID']"
    fi
    gsettings set org.gnome.shell enabled-extensions "$NEW_EXTENSIONS"
fi

# Configurar
SCHEMA_DIR="$HOME/.local/share/gnome-shell/extensions/tilingshell@ferrarodomenico.com/schemas"
LAYOUTS_JSON='[
  {"id": "2 Columnas (50/50)", "tiles": [{"x": 0, "y": 0, "width": 0.5, "height": 1}, {"x": 0.5, "y": 0, "width": 0.5, "height": 1}]},
  {"id": "2 Filas (50/50)", "tiles": [{"x": 0, "y": 0, "width": 1, "height": 0.5}, {"x": 0, "y": 0.5, "width": 1, "height": 0.5}]},
  {"id": "4 Esquinas (2x2)", "tiles": [{"x": 0, "y": 0, "width": 0.5, "height": 0.5}, {"x": 0.5, "y": 0, "width": 0.5, "height": 0.5}, {"x": 0, "y": 0.5, "width": 0.5, "height": 0.5}, {"x": 0.5, "y": 0.5, "width": 0.5, "height": 0.5}]}
]'
gsettings --schemadir "$SCHEMA_DIR" set org.gnome.shell.extensions.tilingshell layouts-json "$LAYOUTS_JSON"
