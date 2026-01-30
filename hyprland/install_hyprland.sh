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

# Instalar Hyprland y Kitty (Rofi se instala por separado)
print_info "Instalando Hyprland y Kitty..."
pacman_install hyprland kitty

print_success "Hyprland y componentes instalados correctamente"
