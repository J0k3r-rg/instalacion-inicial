# Drivers y Utilidades del Sistema

Este directorio contiene scripts modulares para la instalación de drivers y utilidades del sistema en Arch Linux.

## Scripts Disponibles

### 🌐 network_install.sh
**Propósito:** Instalar y configurar NetworkManager para gestión de red.

**Componentes instalados:**
- NetworkManager
- network-manager-applet (applet gráfico)

**Acciones:**
- Habilita el servicio NetworkManager para inicio automático en el arranque

---

### 🔊 audio_install.sh
**Propósito:** Instalar PipeWire como sistema de audio moderno.

**Componentes instalados:**
- pipewire
- pipewire-alsa (compatibilidad ALSA)
- pipewire-pulse (reemplazo de PulseAudio)
- pipewire-jack (compatibilidad JACK)
- wireplumber (gestor de sesiones)
- pavucontrol (control de volumen gráfico)

**Acciones:**
- Elimina PulseAudio si está instalado (conflicto)
- Elimina JACK2 si está instalado (conflicto)

---

### 🎬 codecs_install.sh
**Propósito:** Instalar códecs de video y multimedia para reproducción de contenido.

**Componentes instalados:**
- ffmpeg (framework multimedia)
- gst-plugins-base (plugins base de GStreamer)
- gst-plugins-good (plugins buenos de GStreamer)
- gst-plugins-bad (plugins experimentales de GStreamer)
- gst-plugins-ugly (plugins con restricciones de licencia)
- gst-libav (wrapper de ffmpeg para GStreamer)

---

### 💻 cpu_microcode_install.sh
**Propósito:** Detectar e instalar microcódigo de CPU para AMD o Intel.

**Detección automática:**
- Detecta si la CPU es AMD o Intel
- Pregunta al usuario antes de instalar (modo interactivo)
- Instala automáticamente en modo no interactivo

**Paquetes posibles:**
- `amd-ucode` para CPUs AMD (Ryzen, EPYC, Threadripper)
- `intel-ucode` para CPUs Intel

**Nota:** Después de la instalación, es necesario actualizar el bootloader (GRUB, systemd-boot).

---

### 🎮 gpu_drivers_install.sh
**Propósito:** Detectar e instalar drivers de GPU para NVIDIA, AMD o Intel.

**Detección automática:**
- Analiza las GPUs conectadas mediante `lspci`
- Soporta sistemas con múltiples GPUs
- Pregunta al usuario antes de instalar (modo interactivo)

**Paquetes por fabricante:**

**NVIDIA:**
- nvidia (driver propietario)
- nvidia-utils (utilidades)
- nvidia-settings (panel de control)

**AMD:**
- mesa (driver open-source)
- vulkan-radeon (soporte Vulkan)
- libva-mesa-driver (aceleración de video)

**Intel:**
- mesa (driver open-source)
- vulkan-intel (soporte Vulkan)
- intel-media-driver (aceleración de video)
- libva-mesa-driver (aceleración de video adicional)

---

## Uso Individual

Cada script puede ejecutarse de forma independiente:

```bash
# Instalar NetworkManager
bash drivers_utilities/network_install.sh

# Instalar PipeWire
bash drivers_utilities/audio_install.sh

# Instalar códecs
bash drivers_utilities/codecs_install.sh

# Instalar microcódigo de CPU
bash drivers_utilities/cpu_microcode_install.sh

# Instalar drivers de GPU
bash drivers_utilities/gpu_drivers_install.sh
```

## Integración con install.sh

Estos scripts son llamados automáticamente desde el script principal `install.sh` en el orden apropiado:

1. **PASO 2:** NetworkManager, PipeWire, Códecs
2. **PASO 3:** Microcódigo de CPU, Drivers de GPU

## Modo Interactivo vs No Interactivo

- **Modo Interactivo:** Pregunta antes de instalar cada componente
- **Modo No Interactivo:** Instala automáticamente según la detección de hardware

Los scripts detectan automáticamente si están siendo ejecutados en una terminal interactiva.
