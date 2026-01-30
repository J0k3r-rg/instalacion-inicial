#!/bin/bash

# Script para instalar NetworkManager y componentes de red
# Gestiona la conectividad de red en el sistema

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

print_info "==== Instalación de NetworkManager ===="

# Instalar NetworkManager y applet gráfico
print_info "Instalando NetworkManager y componentes..."
pacman_install networkmanager network-manager-applet

# Habilitar NetworkManager para que inicie en el arranque
print_info "Habilitando servicio NetworkManager..."
sudo systemctl enable NetworkManager.service
sudo systemctl start NetworkManager

print_success "NetworkManager instalado y habilitado"
