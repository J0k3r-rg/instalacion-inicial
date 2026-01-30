#!/bin/bash

# Script para instalar Hyprland y componentes relacionados

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

print_info "==== Instalación de Hyprland y Componentes ===="

# Instalar Hyprland, Kitty, Wofi y Dolphin
print_info "Instalando Hyprland, Kitty, Wofi y Dolphin..."
pacman_install hyprland kitty wofi dolphin

print_success "Hyprland y componentes instalados correctamente"
