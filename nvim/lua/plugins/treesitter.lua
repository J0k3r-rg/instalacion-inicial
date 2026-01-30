return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      -- Nueva API según la documentación de nvim-treesitter (2026)
      -- Ya no se usa require('nvim-treesitter.configs').setup()
      
      -- Instalar parsers de forma síncrona
      require('nvim-treesitter').install({ 
        'lua', 'vim', 'vimdoc', 'query',
        'javascript', 'typescript', 'python', 'java',
        'html', 'css', 'json', 'yaml', 'bash',
        'markdown', 'markdown_inline'  -- Para render-markdown.nvim
      })
    end
  }
}
