#!/bin/bash

# Script para instalar códecs de video y multimedia
# Incluye ffmpeg, GStreamer y plugins para reproducción multimedia

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

print_info "==== Instalación de Códecs de Video y Multimedia ===="

print_info "Instalando ffmpeg y GStreamer con plugins..."
pacman_install \
    ffmpeg \
    gst-plugins-base \
    gst-plugins-good \
    gst-plugins-bad \
    gst-plugins-ugly \
    gst-libav

print_success "Códecs de video y multimedia instalados correctamente"
print_info "Ahora puedes reproducir la mayoría de formatos de video y audio"
