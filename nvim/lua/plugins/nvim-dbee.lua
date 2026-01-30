-- ============================================================================
-- NVIM-DBEE - Cliente de Base de Datos Interactivo
-- Configurado para layout personalizado: o (↑), l (↓), k (←), ñ (→)
-- ============================================================================

return {
    "kndndrj/nvim-dbee",
    dependencies = {
        "MunifTanjim/nui.nvim",
    },
    build = function()
        require("dbee").install()
    end,
    config = function()
        require("dbee").setup({
            -- Configuración del drawer (barra lateral)
            drawer = {
                mappings = {
                    { key = "ñ",     mode = "n", action = "toggle" }, -- Abrir/cerrar nodos
                    -- CAMBIO AQUÍ: Usamos "action_1" para el drawer y "menu_confirm" para los menús
                    { key = "s",     mode = "n", action = "action_1" },
                    { key = "<CR>",  mode = "n", action = "action_1" },         -- Para abrir nodos/scratchpads

                    -- AGREGAR ESTO PARA LOS MENÚS FLOTANTES (Como el de seleccionar DB)
                    { key = "<CR>",  mode = "i", action = "menu_confirm" },
                    { key = "<CR>",  mode = "n", action = "menu_confirm" },
                    { key = "r",     mode = "n", action = "refresh" },
                    { key = "cw",    mode = "n", action = "edit" },   -- Más claro que action_2
                    { key = "dd",    mode = "n", action = "delete" }, -- Más claro que action_3
                    { key = "<Esc>", mode = "n", action = "menu_close" },
                    { key = "q",     mode = "n", action = "menu_close" },
                    { key = "y",     mode = "n", action = "menu_yank" },
                },
            },

            -- Configuración del editor
            editor = {
                mappings = {
                    { key = "<leader>rr", mode = "n", action = "run_file" },
                    { key = "<leader>rs", mode = "v", action = "run_selection" },
                },
            },

            -- Configuración de resultados
            result = {
                page_size = 100,
            },
        })

        -- Atajos globales (sin conflicto con debugger)
        vim.keymap.set("n", "<leader>D", function()
            require("dbee").toggle()
        end, { desc = "DB: Toggle nvim-dbee" })

        vim.keymap.set("n", "<leader>dq", function()
            require("dbee").execute()
        end, { desc = "DB: Ejecutar query" })
    end,
}
