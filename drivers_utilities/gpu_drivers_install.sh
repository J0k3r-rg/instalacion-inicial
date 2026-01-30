#!/bin/bash

# Script para detectar e instalar drivers de GPU (NVIDIA, AMD o Intel)
# Detecta automáticamente el hardware y sugiere los drivers apropiados

set -euo pipefail

# --- Colores para la salida ---
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_info() {
    echo -e "${GREEN}[INFO]${NC} $*"
}

print_success() {
    echo -e "${GREEN}[OK]${NC} $*"
}

print_warning() {
    echo -e "${YELLOW}[AVISO]${NC} $*"
}

die() {
    echo -e "${RED}Error: $*${NC}" >&2
    exit 1
}

pacman_install() {
    sudo pacman -S --needed --noconfirm "$@"
}

print_info "==== Detección e Instalación de Drivers de GPU ===="

# Detectar GPUs
GPU_LINES="$(lspci 2>/dev/null | grep -Ei 'VGA|3D|Display' || true)"

IS_NVIDIA_GPU=false
IS_AMD_GPU=false
IS_INTEL_GPU=false

if echo "$GPU_LINES" | grep -qiE 'NVIDIA'; then
    IS_NVIDIA_GPU=true
fi
if echo "$GPU_LINES" | grep -qiE 'AMD|ATI|Radeon'; then
    IS_AMD_GPU=true
fi
if echo "$GPU_LINES" | grep -qiE 'Intel\(R\)|Intel Corporation'; then
    IS_INTEL_GPU=true
fi

echo -e "${GREEN}GPU(s) detectada(s):${NC}"
if [ -n "$GPU_LINES" ]; then
    echo "$GPU_LINES" | while read -r line; do
        echo "  • $line"
    done
else
    echo "  • No se detectaron GPUs"
fi
echo ""

# ==============================================================================
# NVIDIA
# ==============================================================================
if [ "$IS_NVIDIA_GPU" = true ]; then
    if [ -t 0 ] && [ -t 1 ]; then
        echo -n "Se detectó GPU NVIDIA. ¿Instalar drivers NVIDIA (nvidia/nvidia-utils)? (s/n, por defecto: s): "
        read -r resp_gpu
        case "$resp_gpu" in
            [nN]|[nN][oO])
                print_info "Instalación de drivers NVIDIA omitida"
                ;;
            *)
                print_info "Instalando drivers NVIDIA..."
                pacman_install nvidia nvidia-utils nvidia-settings
                print_success "Drivers NVIDIA instalados"
                print_warning "IMPORTANTE: Reinicia el sistema para que los drivers NVIDIA funcionen correctamente"
                ;;
        esac
    else
        # Modo no interactivo - instalar por defecto
        print_info "Instalando drivers NVIDIA..."
        pacman_install nvidia nvidia-utils nvidia-settings
        print_success "Drivers NVIDIA instalados"
    fi
fi

# ==============================================================================
# AMD
# ==============================================================================
if [ "$IS_AMD_GPU" = true ]; then
    if [ -t 0 ] && [ -t 1 ]; then
        echo -n "Se detectó GPU AMD. ¿Instalar Mesa + Vulkan Radeon? (s/n, por defecto: s): "
        read -r resp_gpu
        case "$resp_gpu" in
            [nN]|[nN][oO])
                print_info "Instalación de drivers AMD omitida"
                ;;
            *)
                print_info "Instalando drivers AMD (Mesa + Vulkan)..."
                pacman_install mesa vulkan-radeon libva-mesa-driver
                print_success "Drivers AMD instalados"
                print_info "Mesa open-source instalado con soporte Vulkan y aceleración de video"
                ;;
        esac
    else
        # Modo no interactivo - instalar por defecto
        print_info "Instalando drivers AMD (Mesa + Vulkan)..."
        pacman_install mesa vulkan-radeon libva-mesa-driver
        print_success "Drivers AMD instalados"
    fi
fi

# ==============================================================================
# Intel
# ==============================================================================
if [ "$IS_INTEL_GPU" = true ]; then
    if [ -t 0 ] && [ -t 1 ]; then
        echo -n "Se detectó GPU Intel. ¿Instalar Mesa + Vulkan Intel + VA-API? (s/n, por defecto: s): "
        read -r resp_gpu
        case "$resp_gpu" in
            [nN]|[nN][oO])
                print_info "Instalación de drivers Intel omitida"
                ;;
            *)
                print_info "Instalando drivers Intel (Mesa + Vulkan + VA-API)..."
                pacman_install mesa vulkan-intel intel-media-driver libva-mesa-driver
                print_success "Drivers Intel instalados"
                print_info "Mesa open-source instalado con soporte Vulkan y aceleración de video"
                ;;
        esac
    else
        # Modo no interactivo - instalar por defecto
        print_info "Instalando drivers Intel (Mesa + Vulkan + VA-API)..."
        pacman_install mesa vulkan-intel intel-media-driver libva-mesa-driver
        print_success "Drivers Intel instalados"
    fi
fi

# ==============================================================================
# Verificación final
# ==============================================================================
if [ "$IS_NVIDIA_GPU" = false ] && [ "$IS_AMD_GPU" = false ] && [ "$IS_INTEL_GPU" = false ]; then
    print_warning "No se detectó ninguna GPU conocida (NVIDIA, AMD, Intel)"
    print_info "Si tienes una GPU, es posible que necesites instalar drivers manualmente"
fi
