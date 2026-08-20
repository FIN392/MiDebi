#!/usr/bin/env bash
set -Eeuo pipefail
trap 'rc=$?; echo "ERROR: \"$BASH_COMMAND\" falló en la línea $LINENO (código de salida: $rc)" >&2; exit "$rc"' ERR

# Instalación de Autofirma (Gobierno de España)

# Desinstalar
sudo apt purge default-jre -y || true
sudo apt purge autofirma* -y || true
sudo apt autoremove -y || true

# Instalar
sudo apt install default-jre -y
curl -L -o /tmp/autofirma.zip "https://firmaelectronica.gob.es/content/dam/firmaelectronica/descargas-software/autofirma19/Autofirma_Linux_Debian.zip"
python3 -m zipfile -e /tmp/autofirma.zip /tmp/
sudo apt install /tmp/autofirma_1_9.deb -y

# Instalar certificados y despues...
# sudo update-ca-certificates

# Configurar
# cat << 'EOF' > /tmp/autofirma_config.afconfig
# <?xml version="1.0" encoding="UTF-8"?>
# <plist version="1.0">
#     <dict>
#         <key>padesVisibleStamp</key><true/>
#         <key>default.locale</key><string>es_ES</string>
#         <key>padesVisibleSignature</key><true/>
#     </dict>
# </plist>
# EOF

# Herremientas / Preferencias / Importar configuración
#     /tmp/autofirma_config.afconfig
