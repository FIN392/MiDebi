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

# Evitar la instalación de paquetes recomendados y sugeridos
print_section "CONFIGURANDO APT"
echo "APT::Install-Recommends \"false\";" | sudo tee /etc/apt/apt.conf.d/98norecommends
echo "APT::Install-Suggests   \"false\";" | sudo tee /etc/apt/apt.conf.d/99nosuggests

# Actualizar
print_section "ACTUALIZANDO EL SISTEMA"
wget -O- https://github.com/FIN392/MiDebi/raw/main/scripts/updateme.sh | bash

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

# Instalar JetBrains font
print_section "INSTALANDO FUENTES JETBRAINS MONO"
sudo apt install fonts-jetbrains-mono -y
fc-cache -f -v

# Configurar gnome-terminal
print_section "CONFIGURANDO TERMINAL"
# Formato de ls
echo alias ls=\'ls -l --color=auto --all --time-style=long-iso\' >> ~/.bashrc
echo alias ls=\'ls -l --color=auto --all --time-style=long-iso\' | sudo tee -a /root/.bashrc
# Ventana de terminal
PROFILE_UUID=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d "'")
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_UUID/ visible-name "$USER"
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_UUID/ use-system-font false
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_UUID/ font 'JetBrains Mono 12'
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_UUID/ default-size-columns 132
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_UUID/ default-size-rows 43

# Configurar escritorio
print_section "CONFIGURANDO ESCRITORIO"
# Fuente por defecto
gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrains Mono 12'
gsettings set org.gnome.desktop.interface document-font-name 'JetBrains Mono 12'
gsettings set org.gnome.desktop.interface font-name 'JetBrains Mono 12'
# Modo oscuro
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
# Fondo negro
gsettings set org.gnome.desktop.background picture-options 'none'
gsettings set org.gnome.desktop.background primary-color '#000000'
# Reloj superior con fecha y 24h
gsettings set org.gnome.desktop.interface clock-format '24h'
gsettings set org.gnome.desktop.interface clock-show-date true
# Botones en ventanas
gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"
# Iconos en escritorio
sudo apt install gnome-shell-extension-desktop-icons-ng -y
gsettings set org.gnome.shell.extensions.ding show-volumes true
gsettings set org.gnome.shell.extensions.ding show-trash false
gsettings set org.gnome.shell.extensions.ding show-home false
gsettings set org.gnome.shell.extensions.ding show-network-volumes true
gnome-extensions enable ding@rastersoft.com
# Quitar aplicaciones del tablero
gsettings set org.gnome.shell favorite-apps "[]"
# Ordenar la cuadrícula de aplicaciones
gsettings set org.gnome.desktop.app-folders folder-children "['']"
gsettings reset org.gnome.shell app-picker-layout
# Dash to panel
sudo apt install gnome-shell-extension-dashtodock -y
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'LEFT'
gsettings set org.gnome.shell.extensions.dash-to-dock show-trash false
gnome-extensions enable dash-to-dock@micxgx.gmail.com

# Instalar y configura Firefox ESR
print_section "INSTALANDO FIREFOX ESR"
wget -O- https://github.com/FIN392/MiDebi/raw/main/scripts/firefox.sh | bash

# Instalar y configura Snapper
print_section "INSTALANDO SNAPPER"
wget -O- https://github.com/FIN392/MiDebi/raw/main/scripts/snapper.sh | bash

# Instalar herramientas
print_section "INSTALANDO HERRAMIENTAS ADICIONALES"
sudo apt install curl fastfetch -y

# Reboot
print_section "REINICIANDO EL SISTEMA"
echo -e "\e[32m✅ Script completado con éxito. El sistema se reiniciará en 5 segundos...\e[0m"
echo -e "\e[33m⚠️  Presiona Ctrl+C para cancelar el reinicio\e[0m"
sleep 5
sudo reboot
