return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "rose-pine", -- Sincronizado con theme.lua
          component_separators = "|",
          section_separators = { left = "", right = "" },
        },
      })
    end,
  },
}
