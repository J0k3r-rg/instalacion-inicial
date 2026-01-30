return {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = function()
        require("toggleterm").setup({
            size = function(term)
                if term.direction == "horizontal" then
                    return 15
                elseif term.direction == "vertical" then
                    return vim.o.columns * 0.4
                elseif term.direction == "float" then
                    return 20
                end
            end,
            open_mapping = nil, -- Deshabilitado, usamos <leader>t en keymaps.lua
            hide_numbers = true,
            shade_terminals = true,
            shading_factor = 2,
            start_in_insert = true,
            insert_mappings = false,
            terminal_mappings = true,
            persist_size = true,
            persist_mode = true,
            direction = 'horizontal', -- Terminal abajo por defecto
            close_on_exit = true,
            shell = vim.o.shell,
            auto_scroll = true,
            -- Terminal se abre en la parte inferior, no desplaza opencode
            on_open = function(term)
                -- Asegurar que los terminales horizontales se abran debajo
                if term.direction == "horizontal" then
                    vim.cmd("wincmd J")
                end
            end,
            float_opts = {
                border = 'curved',
                width = function()
                    return math.floor(vim.o.columns * 0.8)
                end,
                height = function()
                    return math.floor(vim.o.lines * 0.8)
                end,
                winblend = 0,
            },
        })

        -- Atajos de teclado centralizados en lua/core/keymaps.lua
    end,
}
