# Project Install (Arch)

[Español](#español) | [English](#english)

---

## Español

### ¿Qué es este proyecto?

Este repositorio contiene un conjunto de scripts para **automatizar la instalación y configuración inicial** de un sistema Arch Linux (y derivados) después de una instalación desde cero.

El objetivo es que puedas levantar tu entorno rápidamente:

- Instalación de paquetes base y aplicaciones.
- Instalación y configuración de ZSH + Oh My Zsh + Powerlevel10k.
- Instalación de herramientas de desarrollo (NVM, JDK 21, Maven, Docker, etc.).
- Instalación de aplicaciones externas (Windsurf, IntelliJ IDEA) con `.desktop`.
- Copia de configuraciones (Hyprland, Kitty) a `~/.config`.

> Nota: El script principal está pensado para **Arch/pacman**. Muchas partes son interactivas (preguntas) y se ejecutan mejor desde una terminal.

### Cómo se usa

1) Clonar el repo:

```bash
git clone <TU_URL_DEL_REPO> project-install
cd project-install
```

2) Ejecutar:

```bash
chmod +x install.sh
./install.sh
```

El script te va a ir preguntando qué componentes querés instalar (tema de Kitty, Windsurf, IntelliJ, DevTools, Docker, etc.).

### Qué hace `install.sh`

`install.sh` es el **orquestador**. En general:

- **Actualiza el sistema** (`pacman -Syu`).
- Instala dependencias base (`git`, `curl`, `base-devel`, etc.).
- Instala `yay` si no existe (para AUR).
- Instala paquetes del entorno (Hyprland/Kitty/Wofi/Dolphin, fuentes, ZSH).
- Configura ZSH:
  - instala Oh My Zsh (unattended)
  - clona plugins (autosuggestions, syntax-highlighting)
  - instala Powerlevel10k y lo deja como `ZSH_THEME`
  - asegura que `~/.p10k.zsh` se cargue desde `~/.zshrc`
- Agrega utilidades y configuración extra:
  - `fzf`
  - `eza` + aliases en `~/.zshrc`
- Copia configs del repo hacia `~/.config`:
  - `hypr/` -> `~/.config/hypr/`
- Ofrece:
  - cambiar el shell por defecto a ZSH (`chsh`) y manejar `/etc/shells`
  - autoiniciar Hyprland en TTY1 (agrega bloque en `~/.zprofile`)
- Al final puede invocar instaladores “modulares” (separados en carpetas).

### Estructura del repositorio

- `install.sh`
  - Script principal.
- `hypr/`
  - Configuración de Hyprland (ej. `hyprland.conf`).
- `kitty/`
  - `kitty.conf`, `current-theme.conf`.
  - `install_kitty.sh`: copia config y opcionalmente abre el selector de temas.
- `windsurf/`
  - `install_windsurf.sh`: descarga latest, instala en `/opt/windsurf`, crea `.desktop` y ServiceMenu de Dolphin.
- `intellij/`
  - `install_intellij.sh`: descarga latest, instala en `/opt/intellij`, crea `.desktop` y ServiceMenu de Dolphin.
- `devtools/`
  - `install_nvm_jdk_maven.sh`: instala NVM + JDK 21 + Maven y configura `~/.zshrc`.
- `docker/`
  - `install_docker.sh`: instala Docker + Compose, habilita servicio y agrega usuario al grupo `docker`.

### Notas importantes

- **Docker (grupo `docker`)**:
  - Para usar Docker sin `sudo`, es necesario **cerrar sesión y volver a iniciar** (o reiniciar) para que el grupo tenga efecto.
- **Hyprland autostart**:
  - El bloque en `~/.zprofile` inicia Hyprland **solo en TTY1** y solo si no existe `DISPLAY`.
  - Si usás un display manager (SDDM/GDM/greetd), conviene configurarlo ahí.
- **Kitty**:
  - Si tu `kitty.conf` fija `shell bash`, eso va a forzar bash aunque ZSH esté instalado. Ajustá `kitty.conf` a `shell zsh` si querés ZSH siempre.

---

## English

### What is this project?

This repository contains scripts to **automate installation and initial setup** of an Arch Linux (and derivatives) system after a fresh install.

Main goals:

- Install base packages and applications.
- Install and configure ZSH + Oh My Zsh + Powerlevel10k.
- Install developer tooling (NVM, JDK 21, Maven, Docker, etc.).
- Install external apps (Windsurf, IntelliJ IDEA) with `.desktop` launchers.
- Copy configs (Hyprland, Kitty) into `~/.config`.

> Note: The main script is designed for **Arch/pacman**. Many steps are interactive (prompts) and are best run from a terminal.

### Usage

1) Clone:

```bash
git clone <YOUR_REPO_URL> project-install
cd project-install
```

2) Run:

```bash
chmod +x install.sh
./install.sh
```

The script will ask what optional components you want to install (Kitty theme selection, Windsurf, IntelliJ, DevTools, Docker, etc.).

### What `install.sh` does

`install.sh` is the **orchestrator**. In summary:

- **System update** (`pacman -Syu`).
- Installs base dependencies (`git`, `curl`, `base-devel`, etc.).
- Installs `yay` if missing (AUR helper).
- Installs environment packages (Hyprland/Kitty/Wofi/Dolphin, fonts, ZSH).
- Configures ZSH:
  - installs Oh My Zsh (unattended)
  - clones plugins (autosuggestions, syntax-highlighting)
  - installs Powerlevel10k and sets it as `ZSH_THEME`
  - ensures `~/.p10k.zsh` is sourced from `~/.zshrc`
- Adds extra tools:
  - `fzf`
  - `eza` + aliases in `~/.zshrc`
- Copies repo configs into `~/.config`:
  - `hypr/` -> `~/.config/hypr/`
- Offers:
  - switching default shell to ZSH (`chsh`) and handling `/etc/shells`
  - Hyprland autostart on TTY1 (writes a block into `~/.zprofile`)
- Finally, it can call modular installers stored in separate folders.

### Repository layout

- `install.sh` (main)
- `hypr/` (Hyprland config)
- `kitty/` (`kitty.conf`, theme, and `install_kitty.sh`)
- `windsurf/` (`install_windsurf.sh` + `.desktop` + Dolphin ServiceMenu)
- `intellij/` (`install_intellij.sh` + `.desktop` + Dolphin ServiceMenu)
- `devtools/` (`install_nvm_jdk_maven.sh`)
- `docker/` (`install_docker.sh`)

### Important notes

- **Docker group**:
  - To use Docker without `sudo`, you must **log out and log back in** (or reboot) after being added to the `docker` group.
- **Hyprland autostart**:
  - The `~/.zprofile` snippet starts Hyprland only on **TTY1** and only when `$DISPLAY` is empty.
  - If you use a display manager, configure autostart there.
- **Kitty shell**:
  - If your `kitty.conf` sets `shell bash`, it will always start bash even if ZSH is installed. Set it to `shell zsh` to always use ZSH.
