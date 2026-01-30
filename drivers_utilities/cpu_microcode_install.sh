#!/bin/bash

# Script para detectar e instalar microcódigo de CPU (AMD o Intel)
# El microcódigo actualiza el firmware del procesador para corregir errores y vulnerabilidades

set -euo pipefail

# --- Colores para la salida ---
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

print_info() {
    echo -e "${GREEN}[INFO]${NC} $*"
}

print_success() {
    echo -e "${GREEN}[OK]${NC} $*"
}

die() {
    echo -e "${RED}Error: $*${NC}" >&2
    exit 1
}

pacman_install() {
    sudo pacman -S --needed --noconfirm "$@"
}

print_info "==== Detección e Instalación de Microcódigo de CPU ===="

# Detectar CPU
CPU_VENDOR_ID="$(grep -m1 -E '^vendor_id\s*:' /proc/cpuinfo 2>/dev/null | awk -F: '{gsub(/^[ \t]+/,"",$2); print $2}')"
CPU_MODEL_NAME="$(grep -m1 -E '^model name\s*:' /proc/cpuinfo 2>/dev/null | awk -F: '{gsub(/^[ \t]+/,"",$2); print $2}')"

IS_AMD_CPU=false
IS_INTEL_CPU=false

if echo "${CPU_VENDOR_ID} ${CPU_MODEL_NAME}" | grep -qiE 'AuthenticAMD|Ryzen|EPYC|Threadripper'; then
    IS_AMD_CPU=true
fi
if echo "${CPU_VENDOR_ID} ${CPU_MODEL_NAME}" | grep -qiE 'GenuineIntel|Intel\(R\)'; then
    IS_INTEL_CPU=true
fi

echo -e "${GREEN}CPU detectada:${NC} ${CPU_MODEL_NAME:-desconocido}"

# Instalar microcódigo según la CPU detectada
if [ "$IS_AMD_CPU" = true ]; then
    if [ -t 0 ] && [ -t 1 ]; then
        echo -n "Se detectó CPU AMD. ¿Instalar microcódigo amd-ucode? (s/n, por defecto: s): "
        read -r resp_ucode
        case "$resp_ucode" in
            [nN]|[nN][oO])
                print_info "Instalación de microcódigo omitida"
                ;;
            *)
                print_info "Instalando amd-ucode..."
                pacman_install amd-ucode
                print_success "Microcódigo AMD instalado"
                print_info "Actualiza tu bootloader (GRUB, systemd-boot) para aplicar los cambios"
                ;;
        esac
    else
        # Modo no interactivo - instalar por defecto
        print_info "Instalando amd-ucode..."
        pacman_install amd-ucode
        print_success "Microcódigo AMD instalado"
    fi
elif [ "$IS_INTEL_CPU" = true ]; then
    if [ -t 0 ] && [ -t 1 ]; then
        echo -n "Se detectó CPU Intel. ¿Instalar microcódigo intel-ucode? (s/n, por defecto: s): "
        read -r resp_ucode
        case "$resp_ucode" in
            [nN]|[nN][oO])
                print_info "Instalación de microcódigo omitida"
                ;;
            *)
                print_info "Instalando intel-ucode..."
                pacman_install intel-ucode
                print_success "Microcódigo Intel instalado"
                print_info "Actualiza tu bootloader (GRUB, systemd-boot) para aplicar los cambios"
                ;;
        esac
    else
        # Modo no interactivo - instalar por defecto
        print_info "Instalando intel-ucode..."
        pacman_install intel-ucode
        print_success "Microcódigo Intel instalado"
    fi
else
    print_info "No se detectó CPU AMD ni Intel, omitiendo instalación de microcódigo"
fi
