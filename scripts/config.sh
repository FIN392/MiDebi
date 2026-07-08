#!/usr/bin/env bash
set -Eeuo pipefail
# === MANEJO DE ERRORES ===
error_handler() {
  local rc=$?
  local line=$1
  local command=$2
  echo "========================================" >&2
  echo "  ERROR" >&2
  echo "  Línea: $line" >&2
  echo "  Comando: $command" >&2
  echo "  Código de salida: $rc" >&2
  echo "  Directorio: $(pwd)" >&2
  echo "  Usuario: $(whoami)" >&2
  echo "========================================" >&2
  exit "$rc"
}
trap 'error_handler $LINENO "$BASH_COMMAND"' ERR

# Evitar la instalación de paquetes recomendados y sugeridos
echo "APT::Install-Recommends \"false\";" | sudo tee /etc/apt/apt.conf.d/98norecommends
echo "APT::Install-Suggests   \"false\";" | sudo tee /etc/apt/apt.conf.d/99nosuggests

# Actualizar
sudo apt update
sudo apt full-upgrade -y
sudo apt autoremove --purge -y
sudo apt autoclean 
sudo apt clean

# Install GNOME con GDM3
sudo apt install xserver-xorg-core xinit gnome-core -y

# Usar entorno gráfico tras reiniciar
sudo systemctl set-default graphical.target

# Optimización de Discos (SSD)
sudo systemctl enable --now fstrim.timer

# Microcódigo para CPUs de AMD
sudo apt install amd64-microcode -y

# Eliminar software
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

# Formato de ls
echo alias ls=\'ls -l --color=auto --all --time-style=long-iso\' >> ~/.bashrc
echo alias ls=\'ls -l --color=auto --all --time-style=long-iso\' | sudo tee -a /root/.bashrc

# Instalar JetBrains font
sudo apt install fonts-jetbrains-mono -y
fc-cache -f -v

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

# Quitar aplicaciones del tablero
gsettings set org.gnome.shell favorite-apps "[]"

# Configurar gnome-terminal
PROFILE_UUID=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d "'")
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_UUID/ visible-name "$USER"
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_UUID/ use-system-font false
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_UUID/ font 'JetBrains Mono 12'
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_UUID/ default-size-columns 132
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_UUID/ default-size-rows 43

# Iconos en escritorio
sudo apt install gnome-shell-extension-desktop-icons-ng -y
gsettings set org.gnome.shell.extensions.ding show-volumes true
gsettings set org.gnome.shell.extensions.ding show-trash true
gsettings set org.gnome.shell.extensions.ding show-home true
gsettings set org.gnome.shell.extensions.ding show-network-volumes true
gnome-extensions enable ding@rastersoft.com

# Instalar curl
sudo apt install curl -y

# Instalar y configura Snapper
wget -O- https://github.com/FIN392/MiDebi/raw/main/scripts/snapper.sh | bash

# Instalar y configura Firefox ESR
wget -O- https://github.com/FIN392/MiDebi/raw/main/scripts/firefox.sh | bash

sudo reboot
