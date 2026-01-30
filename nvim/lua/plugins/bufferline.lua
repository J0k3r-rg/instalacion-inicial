return {
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",
          separator_style = "slant", -- Estilo elegante para Tokyo Night
          offsets = {
            {
              filetype = "neo-tree",
              text = "Explorador de Archivos",
              text_align = "left",
              separator = true,
            }
          },
        }
      })
    end,
  },
}
