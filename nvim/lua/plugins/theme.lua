return {
    {
        "yorumicolors/yorumi.nvim",
        priority = 1000,
        config = function()
            -- Yorumi no usa una función .setup(), se activa directamente
            vim.cmd("colorscheme yorumi")

            -- Intentamos obtener la paleta de forma segura
            local ok, yorumi_palette = pcall(require, "yorumi.palette")
            if not ok then return end

            local highlights = {
                NotifyBackground = { bg = "#000000" },
                ["@annotation"] = { fg = yorumi_palette.magenta },
                ["@annotation.java"] = { fg = yorumi_palette.yellow },

                -- NVIM-DBEE: Colores para MongoDB
                ["@field.mongodb"] = { fg = yorumi_palette.yellow, bold = true },
                ["@operator.mongodb"] = { fg = yorumi_palette.orange, bold = true },
                ["@string.special.mongodb"] = { fg = yorumi_palette.cyan, italic = true },

                -- JSON
                ["@property.json"] = { fg = yorumi_palette.magenta },
                ["@string.json"] = { fg = yorumi_palette.green },
                ["@number.json"] = { fg = yorumi_palette.orange },
                ["@boolean.json"] = { fg = yorumi_palette.red },

                -- Ventanas flotantes y Dbee
                FloatBorder = { fg = yorumi_palette.comment, bg = "none" },
                FloatTitle = { fg = yorumi_palette.magenta, bold = true },
                DbeeDrawerConnection = { fg = yorumi_palette.blue, bold = true },
                DbeeDrawerActiveConnection = { fg = yorumi_palette.cyan, bold = true, italic = true },
                DbeeResultHeader = { fg = yorumi_palette.magenta, bold = true },
            }

            for group, opts in pairs(highlights) do
                vim.api.nvim_set_hl(0, group, opts)
            end
        end,
    },
}
