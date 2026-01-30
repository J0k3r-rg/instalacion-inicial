return {
  {
    "Exafunction/codeium.nvim",
    -- Forzamos que espere a nvim-cmp para evitar el error de tu captura
    dependencies = {
      "hrsh7th/nvim-cmp",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("codeium").setup({})
    end,
  },
}
