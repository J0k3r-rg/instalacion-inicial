-- ============================================================================
-- SISTEMA DE ZOOM DUAL PARA KITTY + NEOVIM
-- Compatible con Arch Linux y Neovim 0.11.5
-- ============================================================================

local M = {}

-- Estado del zoom
M.is_maximized = false
M.saved_layout = nil
M.zoom_count = 0

-- ============================================================================
-- ZOOM DE FUENTE (Terminal-Side via Kitty)
-- Usa F1/F2/F3 configurados en kitty.conf
-- ============================================================================

--- Aumentar tamaño de fuente enviando F1 a Kitty
function M.zoom_in()
    if vim.env.TERM ~= "xterm-kitty" and not vim.env.KITTY_WINDOW_ID then
        vim.notify("⚠️  Zoom de fuente solo funciona en Kitty", vim.log.levels.WARN)
        return
    end

    -- Enviar tecla F1 (mapeada a increase_font_size en kitty.conf)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<F1>", true, false, true), "n", false)
    M.zoom_count = M.zoom_count + 1

    vim.notify("🔍+ Zoom aumentado", vim.log.levels.INFO, { timeout = 300 })
end

--- Disminuir tamaño de fuente enviando F2 a Kitty
function M.zoom_out()
    if vim.env.TERM ~= "xterm-kitty" and not vim.env.KITTY_WINDOW_ID then
        vim.notify("⚠️  Zoom de fuente solo funciona en Kitty", vim.log.levels.WARN)
        return
    end

    -- Enviar tecla F2 (mapeada a decrease_font_size en kitty.conf)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<F2>", true, false, true), "n", false)
    M.zoom_count = M.zoom_count - 1

    vim.notify("🔍- Zoom disminuido", vim.log.levels.INFO, { timeout = 300 })
end

--- Resetear tamaño de fuente enviando F3 a Kitty
function M.reset_font_size()
    if vim.env.TERM ~= "xterm-kitty" and not vim.env.KITTY_WINDOW_ID then
        vim.notify("⚠️  Zoom de fuente solo funciona en Kitty", vim.log.levels.WARN)
        return
    end

    -- Enviar tecla F3 (mapeada a set_font_size 11 en kitty.conf)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<F3>", true, false, true), "n", false)
    M.zoom_count = 0

    vim.notify("🔄 Fuente reseteada", vim.log.levels.INFO, { timeout = 300 })
end

-- ============================================================================
-- ZOOM DE VENTANA (Neovim-Side)
-- ============================================================================

--- Guarda el layout actual de ventanas
function M.save_layout()
    M.saved_layout = {
        winid = vim.api.nvim_get_current_win(),
        layout = vim.fn.winlayout(),
        neotree_open = #vim.fn.win_findbuf(vim.fn.bufnr("neo-tree")) > 0,
        dbee_open = #vim.fn.win_findbuf(vim.fn.bufnr("dbee-drawer")) > 0,
    }
end

--- Restaura el layout guardado
function M.restore_layout()
    if not M.saved_layout then return end

    -- Restaurar Neotree si estaba abierto
    if M.saved_layout.neotree_open then
        vim.cmd("Neotree show")
    end

    -- Restaurar dbee si estaba abierto
    if M.saved_layout.dbee_open then
        require("dbee").open()
    end

    -- Volver a la ventana original
    if vim.api.nvim_win_is_valid(M.saved_layout.winid) then
        vim.api.nvim_set_current_win(M.saved_layout.winid)
    end

    M.saved_layout = nil
end

--- Maximiza la ventana actual (toggle)
function M.toggle_maximize()
    if M.is_maximized then
        -- Restaurar
        M.restore_layout()
        M.is_maximized = false
        vim.notify("📏 Ventana restaurada", vim.log.levels.INFO, { timeout = 500 })
    else
        -- Maximizar
        M.save_layout()

        -- Cerrar Neotree si está abierto
        pcall(vim.cmd, "Neotree close")

        -- Cerrar dbee si está abierto
        local ok, dbee = pcall(require, "dbee")
        if ok then dbee.close() end

        -- Maximizar la ventana actual
        vim.cmd("only")

        M.is_maximized = true
        vim.notify("🔲 Ventana maximizada", vim.log.levels.INFO, { timeout = 500 })
    end
end

--- Maximizar ventana
function M.maximize()
    if not M.is_maximized then
        M.toggle_maximize()
    end
end

--- Restaurar ventana
function M.restore()
    if M.is_maximized then
        M.toggle_maximize()
    end
end

-- ============================================================================
-- ZOOM COMBINADO (Fuente + Ventana)
-- ============================================================================

--- Zoom completo: maximiza ventana y aumenta fuente
function M.focus_mode()
    M.maximize()
    for _ = 1, 3 do
        vim.defer_fn(function() M.zoom_in() end, 100 * _)
    end
    vim.notify("🎯 Modo Focus activado", vim.log.levels.INFO)
end

--- Salir del modo focus
function M.exit_focus_mode()
    M.restore()
    M.reset_font_size()
    vim.notify("🎯 Modo Focus desactivado", vim.log.levels.INFO)
end

return M
