-- ============================================================================
-- Toggle para LazyGit
-- Permite abrir/cerrar lazygit con el mismo atajo
-- ============================================================================

local M = {}
local lazygit_win = nil
local lazygit_buf = nil

function M.toggle()
    -- Si la ventana existe y es válida, cerrarla
    if lazygit_win and vim.api.nvim_win_is_valid(lazygit_win) then
        vim.api.nvim_win_close(lazygit_win, true)
        lazygit_win = nil
        if lazygit_buf and vim.api.nvim_buf_is_valid(lazygit_buf) then
            vim.api.nvim_buf_delete(lazygit_buf, { force = true })
            lazygit_buf = nil
        end
        return
    end

    -- Si no existe, abrir lazygit
    local prev_win = vim.api.nvim_get_current_win()
    
    -- Crear buffer flotante
    local width = vim.o.columns
    local height = vim.o.lines
    
    local win_height = math.ceil(height * 0.9)
    local win_width = math.ceil(width * 0.9)
    
    local row = math.ceil((height - win_height) / 2)
    local col = math.ceil((width - win_width) / 2)
    
    lazygit_buf = vim.api.nvim_create_buf(false, true)
    
    local opts = {
        style = "minimal",
        relative = "editor",
        width = win_width,
        height = win_height,
        row = row,
        col = col,
        border = "rounded"
    }
    
    lazygit_win = vim.api.nvim_open_win(lazygit_buf, true, opts)
    
    -- Ejecutar lazygit en el terminal
    vim.fn.termopen("lazygit", {
        on_exit = function()
            if lazygit_win and vim.api.nvim_win_is_valid(lazygit_win) then
                pcall(vim.api.nvim_win_close, lazygit_win, true)
            end
            if lazygit_buf and vim.api.nvim_buf_is_valid(lazygit_buf) then
                pcall(vim.api.nvim_buf_delete, lazygit_buf, { force = true })
            end
            lazygit_win = nil
            lazygit_buf = nil
            
            -- Refrescar archivos después de salir de lazygit
            vim.cmd("silent! :checktime")
        end
    })
    
    vim.cmd("startinsert")
end

return M
