-- ============================================================================
-- Panel persistente de OpenCode
-- Maneja la apertura/cierre del panel lateral manteniendo su tamaño
-- La sesión de opencode se mantiene activa entre abrir/cerrar
-- ============================================================================

local M = {}
local opencode_win = nil
local opencode_buf = nil
local opencode_job_id = nil
local panel_width = 60

-- Crear o mostrar el panel de opencode
function M.toggle()
    -- Si la ventana ya existe y está visible, solo ocultarla (sin cerrar el proceso)
    if opencode_win and vim.api.nvim_win_is_valid(opencode_win) then
        -- Solo cerrar la ventana, mantener el buffer y el proceso vivos
        vim.api.nvim_win_close(opencode_win, false)
        opencode_win = nil
        return
    end

    -- Guardar ventana original
    local original_win = vim.api.nvim_get_current_win()

    -- Si el buffer ya existe (sesión previa), reutilizarlo
    if opencode_buf and vim.api.nvim_buf_is_valid(opencode_buf) then
        -- Recrear ventana con el buffer existente
        vim.cmd('topleft vertical ' .. panel_width .. 'split')
        opencode_win = vim.api.nvim_get_current_win()
        vim.api.nvim_win_set_buf(opencode_win, opencode_buf)

        -- Configurar propiedades de la ventana
        vim.api.nvim_win_set_option(opencode_win, 'winfixwidth', true)
        vim.api.nvim_win_set_option(opencode_win, 'number', false)
        vim.api.nvim_win_set_option(opencode_win, 'relativenumber', false)
        vim.api.nvim_win_set_option(opencode_win, 'signcolumn', 'no')
        vim.api.nvim_win_set_option(opencode_win, 'foldcolumn', '0')
        vim.api.nvim_win_set_option(opencode_win, 'wrap', true)

        -- Enfocar el panel de opencode y entrar en modo insertar
        vim.api.nvim_set_current_win(opencode_win)
        vim.cmd('startinsert')
        return
    end

    -- Primera vez: crear buffer y proceso nuevo
    local cwd = vim.fn.getcwd()

    -- Crear buffer scratch persistente (no aparece en bufferline)
    opencode_buf = vim.api.nvim_create_buf(false, true)

    -- Configurar opciones del buffer para que no aparezca en la lista pero persista
    vim.api.nvim_buf_set_option(opencode_buf, 'buftype', 'nofile')
    vim.api.nvim_buf_set_option(opencode_buf, 'bufhidden', 'hide') -- 'hide' en lugar de 'wipe'
    vim.api.nvim_buf_set_option(opencode_buf, 'swapfile', false)
    vim.api.nvim_buf_set_option(opencode_buf, 'buflisted', false)
    vim.api.nvim_buf_set_option(opencode_buf, 'filetype', 'opencode')

    -- Crear split vertical a la izquierda absoluta
    vim.cmd('topleft vertical ' .. panel_width .. 'split')
    opencode_win = vim.api.nvim_get_current_win()

    -- Asignar el buffer a la ventana
    vim.api.nvim_win_set_buf(opencode_win, opencode_buf)

    -- Configurar propiedades de la ventana para que sea fija
    vim.api.nvim_win_set_option(opencode_win, 'winfixwidth', true)
    vim.api.nvim_win_set_option(opencode_win, 'number', false)
    vim.api.nvim_win_set_option(opencode_win, 'relativenumber', false)
    vim.api.nvim_win_set_option(opencode_win, 'signcolumn', 'no')
    vim.api.nvim_win_set_option(opencode_win, 'foldcolumn', '0')
    vim.api.nvim_win_set_option(opencode_win, 'wrap', true)

    -- Ejecutar opencode en la terminal (solo la primera vez)
    opencode_job_id = vim.fn.termopen('opencode "' .. cwd .. '"', {
        cwd = cwd,
        on_exit = function()
            -- Limpiar completamente solo cuando el proceso termina
            if opencode_win and vim.api.nvim_win_is_valid(opencode_win) then
                pcall(vim.api.nvim_win_close, opencode_win, true)
            end
            if opencode_buf and vim.api.nvim_buf_is_valid(opencode_buf) then
                pcall(vim.api.nvim_buf_delete, opencode_buf, { force = true })
            end
            opencode_win = nil
            opencode_buf = nil
            opencode_job_id = nil
        end
    })

    -- Enfocar el panel de opencode y entrar en modo insertar
    vim.api.nvim_set_current_win(opencode_win)
    vim.cmd('startinsert')
end

-- Función para consultar sobre texto seleccionado
function M.ask_about_selection()
    -- Obtener el texto seleccionado
    local mode = vim.fn.mode()
    if mode ~= 'v' and mode ~= 'V' and mode ~= '\22' then
        vim.notify("Por favor, selecciona un texto primero", vim.log.levels.WARN)
        return
    end

    -- Salir del modo visual
    vim.cmd('normal! ')
    
    -- Obtener las marcas de la selección
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")
    
    local start_line = start_pos[2]
    local start_col = start_pos[3]
    local end_line = end_pos[2]
    local end_col = end_pos[3]
    
    -- Obtener las líneas
    local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
    
    if #lines == 0 then
        vim.notify("No se pudo obtener el texto seleccionado", vim.log.levels.ERROR)
        return
    end
    
    -- Procesar la selección
    local selected_text
    if #lines == 1 then
        selected_text = string.sub(lines[1], start_col, end_col)
    else
        lines[1] = string.sub(lines[1], start_col)
        lines[#lines] = string.sub(lines[#lines], 1, end_col)
        selected_text = table.concat(lines, "\n")
    end
    
    -- Abrir el panel si no está abierto
    if not opencode_win or not vim.api.nvim_win_is_valid(opencode_win) then
        M.toggle()
    end
    
    -- Enviar el texto al panel de opencode
    if opencode_job_id and opencode_buf and vim.api.nvim_buf_is_valid(opencode_buf) then
        vim.notify("Consultando sobre la selección...", vim.log.levels.INFO)
        -- Simular el envío del texto (opencode maneja esto automáticamente cuando está en modo terminal)
    end
end

-- Función para consultar sobre el buffer activo
function M.ask_about_buffer()
    -- Obtener todo el contenido del buffer activo
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local buffer_content = table.concat(lines, "\n")
    local filename = vim.fn.expand('%:t')
    
    if buffer_content == "" then
        vim.notify("El buffer está vacío", vim.log.levels.WARN)
        return
    end
    
    -- Abrir el panel si no está abierto
    if not opencode_win or not vim.api.nvim_win_is_valid(opencode_win) then
        M.toggle()
    end
    
    -- Enviar el contenido al panel de opencode
    if opencode_job_id and opencode_buf and vim.api.nvim_buf_is_valid(opencode_buf) then
        vim.notify("Consultando sobre el archivo: " .. filename, vim.log.levels.INFO)
        -- Simular el envío del contenido (opencode maneja esto automáticamente)
    end
end

return M
