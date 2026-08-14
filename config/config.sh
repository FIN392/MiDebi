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

# Install GNOME con GDM3
print_section "INSTALANDO GNOME"
sudo apt install xserver-xorg-core xinit gnome-core -y
sudo systemctl set-default graphical.target

# Eliminar software
print_section "ELIMINANDO SOFTWARE INNECESARIO"
sudo apt purge -y \
  gnome-software \
  gnome-tour \
  gnome-calendar \
  gnome-characters \
  gnome-contacts \
  gnome-weather \
  gnome-maps \
  gnome-clocks \
  gnome-connections \
  gnome-font-viewer \
  totem \
  simple-scan \
  loupe
sudo apt autoremove --purge -y
sudo apt autoclean 
sudo apt clean

# Optimización de hardware
print_section "OPTIMIZACIONES HARDWARE"
        
        # A: Gestión de microcódigo y planificador AMD Zen 3
        sudo systemctl enable --now fstrim.timer
        sudo apt install amd64-microcode -y
        sudo apt install firmware-linux-nonfree -y
        # AMD P-State Driver
        #   > cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_driver
        #   Debe ser 'amd-pstate-epp', si no cambiar en GRUB
        # Daemon Power-Profiles / TLP / GameMode:
        #   > systemctl status power-profiles-daemon
        #   Lo correcto: Deberías ver un texto en verde que indica active (running).
        #   > powerprofilesctl
        #   Te mostrará una lista con los tres perfiles (performance, balanced, power-saver).
        #   El perfil que tiene un asterisco * o aparece marcado como CpuDriver es el que está seleccionado actualmente.
        
        # B: Sensores y monitorización de temperaturas para Asus Nuvoton y ASUS X570
        sudo apt install lm-sensors
        sudo sensors-detect --auto
        echo "nct6775" | sudo tee -a /etc/modules
        
        # C: Ajustes E/S de Almacenamiento y Swap (NVMe / SSD)
        # Reducir la agresividad del swap editando /etc/sysctl.conf:
        #   vm.swappiness=10
        #   vm.vfs_cache_pressure=50
        # Asegurar el programador de I/O adecuado para discos NVMe (none o kyber).

# Instalar herramientas básicas
print_section "INSTALANDO HERRAMIENTAS"
sudo apt install -y \
  curl \
  jq

# Eliminar directorios innecesarios
print_section "ELIMINANDO DIRECTORIOS INNECESARIOS"
rm --force --recursive ~/Imágenes/
rm --force --recursive ~/Música/
rm --force --recursive ~/Público/
rm --force --recursive ~/Vídeos/
\ls --width=1

# Instalar JetBrains font
print_section "INSTALANDO FUENTES JETBRAINS MONO"
sudo apt install fonts-jetbrains-mono -y
fc-cache -f

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
FSTYPE=$(findmnt -n -o FSTYPE /)
if [ "$FSTYPE" = "btrfs" ]; then
  bash "$DIR_ACTUAL/snapper.sh"
else
    echo -e "\e[33m\u26a0 No se instala Snapper. La partición / no usa Btrfs (formato detectado: $FSTYPE).\e[0m"
    sleep 3
fi

# Reboot
print_section "FIN DE LA CONFIGURACION"
read -e -p $'\e[33m\u26a0 ¿Deseas reiniciar el sistema ahora? (s/N): \e[0m' respuesta
case "$respuesta" in
    [sS]|[sS][iI]|[yY]|[yY][eE][sS])
        sudo reboot
        ;;
    *)
        echo -e "\e[36m\u2139 Configuración finalizada.\e[0m"
        ;;
esac
