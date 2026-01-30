local opt = vim.opt

opt.relativenumber = true -- Números de línea relativos (clave para moverse rápido)
opt.number = true         -- Mostrar número de línea actual
opt.tabstop = 4           -- Tamaño de tabulación
opt.shiftwidth = 4
opt.expandtab = true      -- Espacios en vez de tabs
opt.smartindent = true
opt.termguicolors = true  -- Colores reales para Hyprland
opt.cursorline = true     -- Resaltar línea actual
opt.textwidth = 150       -- Tamaño máximo de línea de 150 caracteres
opt.colorcolumn = "150"   -- Mostrar línea visual en la columna 150

-- Autocomando para formatear automáticamente al guardar
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
        -- Usar el formateador de LSP si está disponible (Prettier para JS/TS/JSX/TSX)
        vim.lsp.buf.format({ async = false })
    end,
    desc = "Formatear automáticamente al guardar con LSP"
})
