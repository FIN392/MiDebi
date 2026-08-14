#!/usr/bin/env bash
set -Eeuo pipefail

# === MANEJO DE ERRORES ===
error_handler() {
  local rc=$?
  local line=$1
  local command=$2
  echo -e "\e[31m========================================" >&2
  echo "  ERROR" >&2
  echo "  Línea: $line" >&2
  echo "  Comando: $command" >&2
  echo "  Código de salida: $rc" >&2
  echo "  Directorio: $(pwd)" >&2
  echo "  Usuario: $(whoami)" >&2
  echo -e "========================================\e[0m" >&2
  exit "$rc"
}
trap 'error_handler $LINENO "$BASH_COMMAND"' ERR

# === FUNCIONES ===
print_section() {
  echo -e "\e[36m========================================\e[0m"
  echo -e "\e[36m  $1\e[0m"
  echo -e "\e[36m========================================\e[0m"
}

# === MAIN ===

# Directorio actual
DIR_ACTUAL="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Evitar la instalación de paquetes recomendados y sugeridos
print_section "CONFIGURANDO APT"
echo "APT::Install-Recommends \"false\";" | sudo tee /etc/apt/apt.conf.d/98norecommends
echo "APT::Install-Suggests   \"false\";" | sudo tee /etc/apt/apt.conf.d/99nosuggests

# Actualizar
print_section "ACTUALIZANDO EL SISTEMA"
bash "$DIR_ACTUAL/updateme.sh"

# Optimización de hardware
print_section "OPTIMIZACIONES HARDWARE"
sudo systemctl enable --now fstrim.timer
sudo apt install amd64-microcode -y

# Install GNOME con GDM3
print_section "INSTALANDO GNOME"
sudo apt install xserver-xorg-core xinit gnome-core -y
sudo systemctl set-default graphical.target

# Eliminar software
print_section "ELIMINANDO SOFTWARE INNECESARIO"
sudo apt purge gnome-software -y
sudo apt purge gnome-tour -y
sudo apt purge gnome-calendar -y
sudo apt purge gnome-characters -y
sudo apt purge gnome-contacts -y
sudo apt purge gnome-weather -y
sudo apt purge gnome-maps -y
sudo apt purge gnome-clocks -y
sudo apt purge gnome-connections -y
sudo apt purge gnome-font-viewer -y
sudo apt purge totem -y
sudo apt purge simple-scan -y
sudo apt purge loupe -y
sudo apt autoremove --purge -y
sudo apt autoclean 
sudo apt clean

# Instalar herramientas básicas
print_section "INSTALANDO HERRAMIENTAS"
sudo apt install curl jq -y

# Eliminar directorios innecesarios
print_section "ELIMINANDO DIRECTORIOS INNECESARIOS"
rm --force --recursive ~/Imágenes/
rm --force --recursive ~/Música/
rm --force --recursive ~/Público/
rm --force --recursive ~/Vídeos/

# Instalar JetBrains font
print_section "INSTALANDO FUENTES JETBRAINS MONO"
sudo apt install fonts-jetbrains-mono -y
fc-cache -f -v

# Configurar gnome-terminal
print_section "CONFIGURANDO TERMINAL"
bash "$DIR_ACTUAL/terminalconfig.sh"

# Configurar escritorio
print_section "CONFIGURANDO ESCRITORIO"
bash "$DIR_ACTUAL/gnomeconfig.sh"

# Instalar y configurar Tiling Shell
print_section "INSTALANDO TILING SHELL"
bash "$DIR_ACTUAL/tilingshell.sh"

# Instalar y configura Firefox ESR
print_section "INSTALANDO FIREFOX ESR"
bash "$DIR_ACTUAL/firefox.sh"

# Instalar y configura Snapper
print_section "INSTALANDO SNAPPER"
bash "$DIR_ACTUAL/snapper.sh"

# Reboot
print_section "REINICIANDO EL SISTEMA"
echo -e "\e[32m✅ Script completado con éxito. El sistema se reiniciará en 5 segundos...\e[0m"
echo -e "\e[33m⚠️  Presiona Ctrl+C para cancelar el reinicio\e[0m"
sleep 5
sudo reboot
