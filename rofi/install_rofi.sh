#!/bin/bash

# Script para instalar Rofi y los temas de adi1090x
# https://github.com/adi1090x/rofi

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

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

print_info "==== Instalación de Rofi con temas de adi1090x ===="

# 1. Instalar Rofi y dependencias
print_info "Instalando Rofi y dependencias..."
pacman_install rofi

print_success "Rofi instalado"

# 2. Clonar repositorio de temas adi1090x
ROFI_THEMES_DIR="$HOME/.config/rofi"
TEMP_DIR="$(mktemp -d)"

print_info "Descargando temas de adi1090x..."
git clone --depth=1 https://github.com/adi1090x/rofi.git "$TEMP_DIR/rofi-themes"

# 3. Instalar temas
print_info "Instalando temas..."
cd "$TEMP_DIR/rofi-themes"
chmod +x setup.sh
./setup.sh

print_success "Temas de Rofi instalados"

# 4. Configurar tema por defecto (type-7 style-1)
print_info "Configurando tema por defecto: type-7 style-1..."

# Crear script launcher personalizado
mkdir -p "$HOME/.local/bin"
cat > "$HOME/.local/bin/rofi-launcher" << 'EOF'
#!/usr/bin/env bash

## Author : Aditya Shakya (adi1090x)
## Github : @adi1090x
#
## Rofi   : Launcher (Type-7 Style-1)

dir="$HOME/.config/rofi/launchers/type-7"
theme='style-1'

## Run
rofi \
    -show drun \
    -theme ${dir}/${theme}.rasi
EOF

chmod +x "$HOME/.local/bin/rofi-launcher"

print_success "Launcher de Rofi configurado en ~/.local/bin/rofi-launcher"

# 5. Limpiar
rm -rf "$TEMP_DIR"

print_success "==== Rofi instalado y configurado correctamente ===="
print_info "Tema por defecto: Type-7 Style-1"
print_info "Ejecuta: rofi-launcher (o presiona Super+D en Hyprland)"
print_info "Para cambiar temas, edita: ~/.config/rofi/launchers/type-7/"
