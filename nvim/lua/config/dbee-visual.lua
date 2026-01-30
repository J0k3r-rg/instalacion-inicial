-- ============================================================================
-- NVIM-DBEE: Configuración visual avanzada
-- Autocmds y resaltado personalizado para MongoDB
-- ============================================================================

local M = {}

function M.setup()
    -- Autocomando para detectar buffers de dbee-result y aplicar JSON syntax
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
        pattern = "*",
        callback = function(args)
            local bufname = vim.api.nvim_buf_get_name(args.buf)

            -- Detectar si es un buffer de resultados de dbee
            if bufname:match("dbee%-result") or bufname:match("dbee%-call%-log") then
                vim.bo[args.buf].filetype = "json"
                vim.bo[args.buf].syntax = "json"

                -- Intentar iniciar treesitter
                pcall(vim.treesitter.start, args.buf, "json")

                -- Configuración de visualización
                vim.wo.wrap = false
                vim.wo.number = true
                vim.wo.relativenumber = false
            end

            -- Detectar drawer de dbee
            if bufname:match("dbee%-drawer") then
                vim.wo.number = false
                vim.wo.relativenumber = false
                vim.wo.cursorline = true
            end
        end,
        desc = "nvim-dbee: Aplicar syntax highlighting JSON a resultados"
    })

    -- Resaltado adicional para MongoDB después de cargar el colorscheme
    vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = function()
            -- Operadores MongoDB
            vim.api.nvim_set_hl(0, "@field.mongodb", { fg = "#f6c177", bold = true })
            vim.api.nvim_set_hl(0, "@operator.mongodb", { fg = "#ea9a97", bold = true })
            vim.api.nvim_set_hl(0, "@string.special.mongodb", { fg = "#9ccfd8", italic = true })

            -- Drawer
            vim.api.nvim_set_hl(0, "DbeeDrawerConnection", { fg = "#31748f", bold = true })
            vim.api.nvim_set_hl(0, "DbeeDrawerActiveConnection", { fg = "#9ccfd8", bold = true, italic = true })
            vim.api.nvim_set_hl(0, "DbeeDrawerFolder", { fg = "#6e6a86" })
            vim.api.nvim_set_hl(0, "DbeeDrawerNote", { fg = "#908caa" })
        end,
        desc = "nvim-dbee: Aplicar colores personalizados"
    })
end

return M
