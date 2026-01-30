return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    ft = { 'markdown' },
    opts = {
      -- Renderizar en modo normal
      render_modes = { 'n', 'c' },
      
      -- Configuración de encabezados
      heading = {
        enabled = true,
        sign = true,
        position = 'overlay',
        icons = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
        width = 'full',
        backgrounds = {
          'RenderMarkdownH1Bg',
          'RenderMarkdownH2Bg',
          'RenderMarkdownH3Bg',
          'RenderMarkdownH4Bg',
          'RenderMarkdownH5Bg',
          'RenderMarkdownH6Bg',
        },
      },
      
      -- Configuración de bloques de código
      code = {
        enabled = true,
        sign = true,
        style = 'full',
        position = 'left',
        language_icon = true,
        language_name = true,
        width = 'block',
        left_pad = 2,
        right_pad = 2,
      },
      
      -- Configuración de listas
      bullet = {
        enabled = true,
        icons = { '●', '○', '◆', '◇' },
      },
      
      -- Checkboxes
      checkbox = {
        enabled = true,
        unchecked = { icon = '󰄱 ' },
        checked = { icon = '󰱒 ' },
      },
      
      -- Callouts (notas, advertencias, etc.)
      callout = {
        note = { raw = '[!NOTE]', rendered = '󰋽 Note', highlight = 'RenderMarkdownInfo' },
        tip = { raw = '[!TIP]', rendered = '󰌶 Tip', highlight = 'RenderMarkdownSuccess' },
        important = { raw = '[!IMPORTANT]', rendered = '󰅾 Important', highlight = 'RenderMarkdownHint' },
        warning = { raw = '[!WARNING]', rendered = '󰀪 Warning', highlight = 'RenderMarkdownWarn' },
        caution = { raw = '[!CAUTION]', rendered = '󰳦 Caution', highlight = 'RenderMarkdownError' },
      },
      
      -- Anti-conceal: mostrar texto original en la línea del cursor
      anti_conceal = {
        enabled = true,
      },
    },
  }
}
