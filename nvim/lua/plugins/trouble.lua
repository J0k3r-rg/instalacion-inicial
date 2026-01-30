-- ~/.config/nvim/lua/plugins/trouble.lua
return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("trouble").setup({
      icons = true,
      fold_open = "",
      fold_closed = "",
      indent_lines = false,
      signs = {
        error = "",
        warning = "",
        hint = "",
        information = "",
      },
    })
    -- Atajos de teclado centralizados en lua/core/keymaps.lua
  end,
}