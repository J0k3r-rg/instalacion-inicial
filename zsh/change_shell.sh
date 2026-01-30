#!/bin/bash

# Script para cambiar el shell por defecto a ZSH

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

print_info "==== Cambio de Shell a ZSH ===="

ZSH_BIN="$(command -v zsh)"

if [ -z "$ZSH_BIN" ]; then
    die "ZSH no está instalado. Ejecuta primero install_zsh.sh"
fi

ensure_zsh_in_etc_shells() {
    if [ -r /etc/shells ] && ! grep -qxF "$ZSH_BIN" /etc/shells; then
        if [ -t 0 ] && [ -t 1 ]; then
            echo "El shell '$ZSH_BIN' no está listado en /etc/shells. chsh puede fallar por esto."
            echo -n "¿Deseas agregarlo a /etc/shells ahora? (s/n, por defecto: s): "
            read -r add_shells
            case "$add_shells" in
                [nN]|[nN][oO])
                    ;;
                *)
                    print_info "Agregando $ZSH_BIN a /etc/shells..."
                    echo "$ZSH_BIN" | sudo tee -a /etc/shells >/dev/null
                    ;;
            esac
        else
            echo "Aviso: '$ZSH_BIN' no está en /etc/shells. Si chsh falla, agrega esta línea a /etc/shells."
        fi
    fi
}

if [ "${SHELL:-}" != "$ZSH_BIN" ]; then
    if [ -t 0 ] && [ -t 1 ]; then
        echo -n "¿Deseas cambiar tu shell por defecto a ZSH ahora? (s/n, por defecto: s): "
        read -r shell_response
        case "$shell_response" in
            [nN]|[nN][oO])
                echo "Shell por defecto mantenido. Para cambiar manualmente: chsh -s $ZSH_BIN"
                ;;
            *)
                ensure_zsh_in_etc_shells
                print_info "Cambiando shell por defecto a ZSH..."
                if chsh -s "$ZSH_BIN"; then
                    print_success "Shell cambiado a ZSH exitosamente"
                    print_info "IMPORTANTE: Reinicia tu sesión o abre una nueva terminal para usar ZSH"
                else
                    echo -e "${RED}No se pudo cambiar el shell por defecto.${NC}"
                    echo "Posibles causas: zsh no está en /etc/shells, contraseña incorrecta, políticas del sistema."
                    echo "Prueba: grep -xF '$ZSH_BIN' /etc/shells || echo '$ZSH_BIN' | sudo tee -a /etc/shells"
                    echo "Luego: chsh -s '$ZSH_BIN'"
                fi
                ;;
        esac
    else
        ensure_zsh_in_etc_shells
        print_info "Cambiando shell por defecto a ZSH..."
        if chsh -s "$ZSH_BIN"; then
            print_success "Shell cambiado a ZSH exitosamente"
        else
            echo -e "${RED}No se pudo cambiar el shell por defecto.${NC}"
        fi
    fi
else
    print_success "Ya estás usando ZSH como shell por defecto."
fi
