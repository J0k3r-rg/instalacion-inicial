-- ============================================================================
-- PANEL DE AYUDA DE KEYMAPS
-- Muestra una ventana flotante con todos los atajos de teclado organizados
-- ============================================================================

local M = {}

-- Contenido de la ayuda de keymaps organizado por categorías
local function get_help_content()
  return [[
╔══════════════════════════════════════════════════════════════════════════════╗
║                          GUÍA DE ATAJOS DE TECLADO                           ║
╚══════════════════════════════════════════════════════════════════════════════╝

┌─ NAVEGACIÓN BÁSICA ────────────────────────────────────────────────────────┐
│ o/l/k/ñ          Mover arriba/abajo/izquierda/derecha                      │
│ j/{              Ir al inicio/final de línea                               │
│ <M-o>/<M-l>      Scroll 1/4 de página arriba/abajo                         │
└────────────────────────────────────────────────────────────────────────────┘

┌─ EDICIÓN BÁSICA ───────────────────────────────────────────────────────────┐
│ i                Insertar en posición actual                               │
│ p/P              Insertar después/al final de línea                        │
│ O/L              Insertar línea arriba/abajo                               │
│ w/q              Guardar archivo / Cerrar buffer                           │
│ z/Z              Deshacer / Rehacer                                        │
│ Q                Cerrar todo y salir                                       │
└────────────────────────────────────────────────────────────────────────────┘

┌─ CORTAR, COPIAR Y PEGAR ───────────────────────────────────────────────────┐
│ x / xx           Cortar (con movimiento) / Cortar línea                    │
│ c / cc           Copiar (con movimiento) / Copiar línea                    │
│ v / V            Pegar después / Pegar antes                               │
│ > / <            Identar derecha / izquierda                               │
└────────────────────────────────────────────────────────────────────────────┘

┌─ SELECCIÓN VISUAL (s*) ────────────────────────────────────────────────────┐
│ s                Entrar al modo visual (carácter por carácter)            │
│ sw               Seleccionar palabra                                       │
│ sl               Seleccionar línea completa                                │
│ se               Seleccionar hasta el final de línea                       │
│ ss               Seleccionar hasta el inicio de línea                      │
│ <C-d>            Seleccionar palabra bajo cursor (alternativa)             │
│ K/Ñ              Seleccionar hasta inicio/final de línea (alternativa)     │
└────────────────────────────────────────────────────────────────────────────┘

┌─ NAVEGACIÓN VENTANAS Y BUFFERS ────────────────────────────────────────────┐
│ <C-k/l/o/ñ>      Ir a ventana izq/abajo/arriba/der                         │
│ <M-k>/<M-ñ>      Buffer anterior/siguiente                                 │
│ <leader>1-9      Ir a buffer específico                                    │
│ <leader>x        Cerrar buffer actual                                      │
│ e                Abrir/Cerrar árbol de archivos (Neotree)                  │
└────────────────────────────────────────────────────────────────────────────┘

┌─ BÚSQUEDA (Telescope) ─────────────────────────────────────────────────────┐
│ <leader><leader> Buscar archivos (rápido)                                  │
│ <leader>b        Buscar palabras en archivos                               │
│ <leader>ff       Buscar archivos                                           │
│ <leader>fg       Buscar texto (grep)                                       │
│ <leader>fb       Ver buffers abiertos                                      │
│ <leader>fs       Símbolos del documento                                    │
└────────────────────────────────────────────────────────────────────────────┘

┌─ GIT (<leader>g*) ─────────────────────────────────────────────────────────┐
│ <leader>gg       Abrir/cerrar LazyGit                                      │
│ <leader>ga       Git add (agregar archivos)                                │
│ <leader>gc       Git commit                                                │
│ <leader>gC       Git add + commit + push (todo en uno)                     │
│ <leader>gp       Git pull                                                  │
│ <leader>gP       Git push                                                  │
│ <leader>gb       Nueva rama                                                │
│ <leader>go       Checkout rama                                             │
│ <leader>gs       Git status                                                │
│ <leader>gr       Git restore (deshacer cambios)                            │
└────────────────────────────────────────────────────────────────────────────┘

┌─ OPENCODE (<leader>a*) ────────────────────────────────────────────────────┐
│ <leader>aa       Abrir/cerrar panel de OpenCode                            │
│ <leader>ac       Consultar sobre selección (modo visual)                   │
│ <leader>as       Consultar sobre buffer activo                             │
└────────────────────────────────────────────────────────────────────────────┘

┌─ LSP (Navegación de Código) ──────────────────────────────────────────────┐
│ gd               Ir a definición                                           │
│ gD               Ir a declaración                                          │
│ gi               Ir a implementación                                       │
│ gr               Ver referencias                                           │
│ gt               Ir a definición de tipo                                   │
│ K                Mostrar documentación (hover)                             │
│ <leader>rn       Renombrar símbolo                                         │
│ <leader>ca       Acciones de código                                        │
│ <leader>f        Formatear código                                          │
│ [d / ]d          Diagnóstico anterior/siguiente                            │
│ <leader>e        Mostrar diagnóstico flotante                              │
│ <C-.>            Ver error en línea actual                                 │
└────────────────────────────────────────────────────────────────────────────┘

┌─ TERMINAL (<leader>t*) ────────────────────────────────────────────────────┐
│ <leader>t        Toggle terminal horizontal                                │
│ <leader>T        Toggle terminal flotante                                  │
│ <Esc>            Salir de modo insert en terminal                          │
└────────────────────────────────────────────────────────────────────────────┘

┌─ ERRORES Y DIAGNÓSTICOS (<leader>x*) ─────────────────────────────────────┐
│ <leader>xx       Trouble: Todos los errores                                │
│ <leader>xd       Trouble: Errores del archivo actual                       │
│ <leader>xs       Trouble: Símbolos                                         │
│ <leader>xl       Trouble: Info LSP                                         │
└────────────────────────────────────────────────────────────────────────────┘

┌─ DEBUGGER (DAP) ───────────────────────────────────────────────────────────┐
│ <F5>             Iniciar/Continuar debug                                   │
│ <F10>            Paso sobre (Step Over)                                    │
│ <F11>            Paso dentro (Step Into)                                   │
│ <F12>            Paso fuera (Step Out)                                     │
│ <leader>db       Toggle breakpoint                                         │
│ <leader>dB       Breakpoint condicional                                    │
│ <leader>du       Toggle Debug UI                                           │
└────────────────────────────────────────────────────────────────────────────┘

┌─ SPRING BOOT & REACT (<leader>s*) ────────────────────────────────────────┐
│ <leader>ss       Spring Boot: Ejecutar                                     │
│ <leader>sS       Spring Boot: Detener                                      │
│ <leader>sr       React Router 7: Ejecutar                                  │
│ <leader>sR       React Router 7: Detener                                   │
└────────────────────────────────────────────────────────────────────────────┘

┌─ DOCKER (<leader>k*) ──────────────────────────────────────────────────────┐
│ <leader>ku       Docker Compose Up                                         │
│ <leader>kd       Docker Compose Down                                       │
│ <leader>kl       Docker Compose Logs                                       │
│ <leader>ks       Docker Compose PS (ver estado)                            │
└────────────────────────────────────────────────────────────────────────────┘

┌─ BASE DE DATOS (<leader>D) ────────────────────────────────────────────────┐
│ <leader>D        Abrir/Cerrar nvim-dbee                                    │
│ <leader>dq       Ejecutar query                                            │
│ <leader>rr       Ejecutar archivo completo (en editor)                     │
│ <leader>rs       Ejecutar selección (modo visual)                          │
│ ñ                Expandir/colapsar nodos (en drawer)                       │
│ <CR>             Abrir/activar conexión o scratchpad                       │
│ r                Refrescar (en drawer)                                     │
│ cw               Renombrar (en drawer)                                     │
│ dd               Eliminar (en drawer)                                      │
└────────────────────────────────────────────────────────────────────────────┘

┌─ ZOOM Y FOCUS (<leader>z*) ────────────────────────────────────────────────┐
│ <leader>z+/-     Zoom in/out de fuente (Kitty)                             │
│ <leader>z0       Resetear tamaño de fuente                                 │
│ <C-w>m           Maximizar/Restaurar ventana                               │
│ <leader>zf       Activar modo focus                                        │
│ <leader>zF       Desactivar modo focus                                     │
└────────────────────────────────────────────────────────────────────────────┘

┌─ JAVA (Solo archivos .java) ──────────────────────────────────────────────┐
│ <leader>jo       Organizar imports                                         │
│ <leader>jv       Extraer variable                                          │
│ <leader>jc       Extraer constante                                         │
│ <leader>jm       Extraer método (modo visual)                              │
│ <leader>tc       Ejecutar test de clase                                    │
│ <leader>tm       Ejecutar test del método actual                           │
└────────────────────────────────────────────────────────────────────────────┘

┌─ AYUDA ────────────────────────────────────────────────────────────────────┐
│ <leader>?        Mostrar esta ayuda                                        │
│ <Esc> o q        Cerrar esta ventana de ayuda                              │
└────────────────────────────────────────────────────────────────────────────┘

  Presiona <Esc> o q para cerrar esta ventana
]]
end

-- Mostrar la ventana flotante con los keymaps
function M.show()
  -- Crear buffer scratch para la ayuda
  local buf = vim.api.nvim_create_buf(false, true)
  
  -- Obtener el contenido de la ayuda
  local content = get_help_content()
  local lines = vim.split(content, '\n')
  
  -- Establecer el contenido en el buffer
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  
  -- Hacer el buffer de solo lectura
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  vim.api.nvim_buf_set_option(buf, 'swapfile', false)
  
  -- Calcular tamaño de la ventana (90% del ancho y alto)
  local width = math.floor(vim.o.columns * 0.9)
  local height = math.floor(vim.o.lines * 0.9)
  
  -- Calcular posición centrada
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)
  
  -- Configuración de la ventana flotante
  local opts = {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
    title = ' Guía de Atajos de Teclado ',
    title_pos = 'center',
  }
  
  -- Crear la ventana flotante
  local win = vim.api.nvim_open_win(buf, true, opts)
  
  -- Configurar opciones de la ventana
  vim.api.nvim_win_set_option(win, 'winblend', 5)
  vim.api.nvim_win_set_option(win, 'wrap', false)
  vim.api.nvim_win_set_option(win, 'cursorline', true)
  
  -- Mapeos para cerrar la ventana
  local close_keys = { 'q', '<Esc>' }
  for _, key in ipairs(close_keys) do
    vim.api.nvim_buf_set_keymap(buf, 'n', key, '<cmd>close<cr>',
      { noremap = true, silent = true })
  end
  
  -- Permitir scroll con las teclas personalizadas (o/l)
  vim.api.nvim_buf_set_keymap(buf, 'n', 'o', 'k',
    { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', 'l', 'j',
    { noremap = true, silent = true })
end

return M
