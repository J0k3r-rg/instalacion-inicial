#!/bin/bash

# ============================================================================
# Script de instalación y configuración de SSH
# Instala OpenSSH, copia configuración y opcionalmente genera claves SSH
# ============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

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
    echo -e "${YELLOW}[ADVERTENCIA]${NC} $*"
}

die() {
    echo -e "${RED}Error: $*${NC}" >&2
    exit 1
}

require_cmd() {
    command -v "$1" >/dev/null 2>&1 || die "Falta el comando requerido: $1"
}

pacman_install() {
    sudo pacman -S --needed --noconfirm "$@"
}

require_cmd sudo
require_cmd pacman

echo "============================================"
echo "Instalador y Configurador de SSH"
echo "============================================"
echo ""

# 1. Instalación de OpenSSH
print_info "Instalando OpenSSH..."
pacman_install openssh

# 2. Habilitar y arrancar el servicio SSH
print_info "Habilitando servicio SSH..."
sudo systemctl enable sshd.service
sudo systemctl start sshd.service
print_success "Servicio SSH habilitado y en ejecución"

# 3. Crear directorio .ssh si no existe
print_info "Preparando directorio ~/.ssh..."
mkdir -p "${HOME}/.ssh"
chmod 700 "${HOME}/.ssh"
print_success "Directorio ~/.ssh preparado con permisos correctos"

# 4. Copiar archivo de configuración SSH
SSH_CONFIG_SOURCE="${SCRIPT_DIR}/config"
SSH_CONFIG_DEST="${HOME}/.ssh/config"

if [ -f "$SSH_CONFIG_SOURCE" ]; then
    print_info "Copiando archivo de configuración SSH..."
    
    if [ -f "$SSH_CONFIG_DEST" ]; then
        if [ -t 0 ] && [ -t 1 ]; then
            echo -n "Ya existe un archivo config en ~/.ssh. ¿Deseas sobreescribirlo? (s/n, por defecto: n): "
            read -r overwrite_config
            case "$overwrite_config" in
                [sS]|[sS][iI])
                    # Hacer backup del archivo existente
                    backup_file="${SSH_CONFIG_DEST}.backup.$(date +%Y%m%d_%H%M%S)"
                    cp "$SSH_CONFIG_DEST" "$backup_file"
                    print_info "Backup guardado en: $backup_file"
                    
                    cp "$SSH_CONFIG_SOURCE" "$SSH_CONFIG_DEST"
                    chmod 600 "$SSH_CONFIG_DEST"
                    print_success "Archivo config copiado y permisos establecidos"
                    ;;
                *)
                    print_warning "Manteniendo archivo config existente"
                    ;;
            esac
        else
            # En modo no interactivo, no sobreescribir
            print_warning "Archivo config ya existe. No se sobreescribió"
        fi
    else
        cp "$SSH_CONFIG_SOURCE" "$SSH_CONFIG_DEST"
        chmod 600 "$SSH_CONFIG_DEST"
        print_success "Archivo config copiado y permisos establecidos"
    fi
else
    print_warning "No se encontró archivo de configuración en: $SSH_CONFIG_SOURCE"
fi

# 5. Generar clave SSH (opcional)
if [ -t 0 ] && [ -t 1 ]; then
    echo ""
    echo "============================================"
    echo "Generación de Clave SSH"
    echo "============================================"
    echo ""
    
    # Verificar si ya existe la clave
    SSH_KEY_PATH="${HOME}/.ssh/id_ed25519"
    
    if [ -f "$SSH_KEY_PATH" ]; then
        print_warning "Ya existe una clave SSH en: $SSH_KEY_PATH"
        echo -n "¿Deseas generar una nueva clave? (Esto sobrescribirá la existente) (s/n, por defecto: n): "
        read -r generate_new_key
    else
        echo -n "¿Deseas generar una clave SSH ed25519 ahora? (s/n, por defecto: s): "
        read -r generate_new_key
    fi
    
    case "$generate_new_key" in
        [sS]|[sS][iI])
            echo ""
            print_info "Generando clave SSH ed25519..."
            echo ""
            
            # Pedir email para el comentario de la clave
            echo -n "Ingresa tu email para identificar la clave (opcional, presiona Enter para omitir): "
            read -r ssh_email
            
            if [ -n "$ssh_email" ]; then
                ssh-keygen -t ed25519 -C "$ssh_email" -f "$SSH_KEY_PATH"
            else
                ssh-keygen -t ed25519 -f "$SSH_KEY_PATH"
            fi
            
            # Establecer permisos correctos
            chmod 600 "$SSH_KEY_PATH"
            chmod 644 "${SSH_KEY_PATH}.pub"
            
            echo ""
            print_success "Clave SSH generada exitosamente!"
            echo ""
            echo "============================================"
            echo "Tu clave pública es:"
            echo "============================================"
            cat "${SSH_KEY_PATH}.pub"
            echo "============================================"
            echo ""
            print_info "Puedes copiar esta clave pública a tus servidores remotos"
            print_info "Ubicación de la clave privada: $SSH_KEY_PATH"
            print_info "Ubicación de la clave pública: ${SSH_KEY_PATH}.pub"
            ;;
        [nN]|[nN][oO])
            print_info "Generación de clave SSH omitida"
            ;;
        *)
            if [ -f "$SSH_KEY_PATH" ]; then
                print_info "Generación de clave SSH omitida (se mantiene la existente)"
            else
                print_info "Generando clave SSH ed25519 (opción por defecto)..."
                echo ""
                
                echo -n "Ingresa tu email para identificar la clave (opcional, presiona Enter para omitir): "
                read -r ssh_email
                
                if [ -n "$ssh_email" ]; then
                    ssh-keygen -t ed25519 -C "$ssh_email" -f "$SSH_KEY_PATH"
                else
                    ssh-keygen -t ed25519 -f "$SSH_KEY_PATH"
                fi
                
                chmod 600 "$SSH_KEY_PATH"
                chmod 644 "${SSH_KEY_PATH}.pub"
                
                echo ""
                print_success "Clave SSH generada exitosamente!"
                echo ""
                echo "============================================"
                echo "Tu clave pública es:"
                echo "============================================"
                cat "${SSH_KEY_PATH}.pub"
                echo "============================================"
            fi
            ;;
    esac
fi

echo ""
echo "============================================"
print_success "Configuración de SSH completada!"
echo "============================================"
echo ""
echo "📋 Resumen:"
echo ""
echo "✓ OpenSSH instalado y servicio habilitado"
echo "✓ Directorio ~/.ssh configurado con permisos correctos"
if [ -f "$SSH_CONFIG_DEST" ]; then
    echo "✓ Archivo de configuración SSH copiado en ~/.ssh/config"
fi
if [ -f "${HOME}/.ssh/id_ed25519" ]; then
    echo "✓ Clave SSH generada en ~/.ssh/id_ed25519"
fi
echo ""
echo "📝 Próximos pasos:"
echo ""
echo "1. Edita ~/.ssh/config para actualizar los hosts y direcciones IP"
echo "2. Copia tu clave pública a los servidores remotos:"
echo "   ssh-copy-id -i ~/.ssh/id_ed25519.pub usuario@servidor"
echo ""
echo "3. Verifica la conexión SSH:"
echo "   ssh usuario@servidor"
echo ""
echo "============================================"
