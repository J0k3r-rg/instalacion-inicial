return {
  {
    'nvim-telescope/telescope.nvim',
    branch = 'master',
    dependencies = { 
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('telescope').setup({
        defaults = {
          -- Configuración mínima y segura
          layout_strategy = 'horizontal',
          layout_config = {
            horizontal = {
              preview_width = 0.55,
            },
          },
        },
      })
    end
  }
}
