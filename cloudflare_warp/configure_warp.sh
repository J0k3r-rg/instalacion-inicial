#!/bin/bash

# Script para configurar Cloudflare WARP
# Nota: El paquete cloudflare-warp-bin debe estar instalado previamente desde AUR

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

print_info "==== Configuración de Cloudflare WARP ===="

if ! pacman -Qs cloudflare-warp-bin > /dev/null 2>&1; then
    print_info "Cloudflare WARP no está instalado, saltando configuración..."
    exit 0
fi

print_info "Habilitando servicio warp-svc..."
sudo systemctl enable --now warp-svc

print_info "Esperando a que el servicio inicie correctamente..."
sleep 5

if command -v warp-cli >/dev/null 2>&1; then
    if ! warp-cli settings > /dev/null 2>&1; then
        print_info "Registrando nuevo cliente WARP (Aceptando TOS)..."
        echo "y" | warp-cli registration new
        sleep 2
    fi

    print_info "Configurando modo WARP y conectando..."
    warp-cli mode warp
    warp-cli connect

    HYPR_CONF="$HOME/.config/hypr/hyprland.conf"
    mkdir -p "$(dirname "$HYPR_CONF")"
    touch "$HYPR_CONF"

    if ! grep -q "warp-cli connect" "$HYPR_CONF"; then
        print_info "Agregando inicio automático a Hyprland..."
        echo "" >> "$HYPR_CONF"
        echo "# Cloudflare WARP Auto-Connect" >> "$HYPR_CONF"
        echo "exec-once = warp-cli connect" >> "$HYPR_CONF"
        print_success "Configuración de Hyprland actualizada."
    else
        print_info "La configuración de Hyprland ya incluye WARP."
    fi

    print_success "Cloudflare WARP configurado y activo."
else
    die "Se instaló cloudflare-warp-bin pero no se encontró warp-cli en PATH."
fi
