#!/usr/bin/env bash
set -Eeuo pipefail
trap 'rc=$?; echo "ERROR: \"$BASH_COMMAND\" falló en la línea $LINENO (código de salida: $rc)" >&2; exit "$rc"' ERR

# Instalación de Autofirma (Gobierno de España)

# Desinstalar
sudo apt purge firefox* -y
# sudo rm --force --recursive /usr/lib/firefox-esr
# sudo rm --force --recursive /usr/share/firefox-esr
# rm --force --recursive ~/.mozilla/firefox
# rm --force --recursive ~/.cache/mozilla/firefox

# Instalar
curl -L -o /tmp/autofirma.zip "https://firmaelectronica.gob.es/content/dam/firmaelectronica/descargas-software/autofirma19/Autofirma_Linux_Debian.zip"




# sudo apt install firefox-esr-l10n-es-es -y


# Configurar

