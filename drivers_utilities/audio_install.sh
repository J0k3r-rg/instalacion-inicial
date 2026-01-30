#!/bin/bash

# Script para instalar PipeWire y componentes de audio
# PipeWire es el sistema de audio moderno que reemplaza PulseAudio y JACK

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

print_info "==== Instalación de PipeWire (Sistema de Audio) ===="

# Eliminar pulseaudio si está instalado (conflicto con pipewire-pulse)
if pacman -Qs pulseaudio > /dev/null 2>&1; then
    print_info "Eliminando PulseAudio (incompatible con pipewire-pulse)..."
    sudo pacman -Rdd --noconfirm pulseaudio 2>/dev/null || true
    print_success "PulseAudio eliminado"
fi

# Eliminar jack2 si está instalado (conflicto con pipewire-jack)
if pacman -Qs jack2 > /dev/null 2>&1; then
    print_info "Eliminando JACK2 (incompatible con pipewire-jack)..."
    sudo pacman -Rdd --noconfirm jack2 2>/dev/null || true
    print_success "JACK2 eliminado"
fi

# Instalar PipeWire y sus componentes
print_info "Instalando PipeWire y componentes..."
pacman_install pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber

# Instalar control de volumen gráfico
print_info "Instalando PavuControl (control de volumen gráfico)..."
pacman_install pavucontrol

print_success "PipeWire instalado correctamente"
print_info "PipeWire se iniciará automáticamente con tu sesión de usuario"
