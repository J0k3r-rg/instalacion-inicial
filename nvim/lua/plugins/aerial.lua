return {
  "stevearc/aerial.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("aerial").setup({
      -- Configuración optimizada para Java/Spring
      backends = { "lsp", "treesitter", "markdown", "asciidoc", "man" },
      
      -- Muestra íconos de tipos (class, method, field, etc.)
      show_guides = true,
      
      -- Diseño del panel lateral
      layout = {
        max_width = { 40, 0.2 }, -- Máximo 40 caracteres o 20% de la pantalla
        width = nil,
        min_width = 25,
        default_direction = "right", -- Abre a la derecha
        placement = "edge",
      },
      
      -- Filtros para Java: muestra todo lo importante
      filter_kind = {
        "Class",
        "Constructor",
        "Enum",
        "Function",
        "Interface",
        "Module",
        "Method",
        "Struct",
        "Field",
        "Property",
        "Constant",
      },
      
      -- Resaltado automático del símbolo actual
      highlight_on_hover = true,
      
      -- Sincronización automática con el cursor
      autojump = false, -- No salta automáticamente al cambiar de línea
      
      -- Mantener el panel abierto al cambiar de buffer
      attach_mode = "global",
      
      -- Comportamiento al abrir/cerrar
      close_automatic_events = {},
      
      -- UI mejorada
      icons = {
        collapsed = "",
        -- Se usan los íconos de nvim-web-devicons automáticamente
      },
      
      -- Navegación con teclado (mismo sistema que neotree)
      keymaps = {
        ["?"] = "actions.show_help",
        ["g?"] = "actions.show_help",
        
        -- Navegación arriba/abajo (o = arriba, l = abajo)
        ["o"] = "actions.prev",           -- Subir en la lista
        ["l"] = "actions.next",           -- Bajar en la lista
        
        -- Seleccionar/abrir símbolo (ñ = abrir/saltar)
        ["ñ"] = "actions.jump",           -- Saltar al símbolo
        ["<CR>"] = "actions.jump",        -- Enter también funciona
        ["<2-LeftMouse>"] = "actions.jump",
        
        -- Abrir en split
        ["<C-v>"] = "actions.jump_vsplit",
        ["<C-s>"] = "actions.jump_split",
        
        -- Cerrar ventana
        ["q"] = "actions.close",
        ["k"] = "actions.close",          -- k para cerrar (como en neotree)
        
        -- Expandir/colapsar árbol (mantener alternativas)
        ["za"] = "actions.tree_toggle",
        ["O"] = "actions.tree_toggle_recursive",
        ["zA"] = "actions.tree_toggle_recursive",
        
        -- Scroll
        ["p"] = "actions.scroll",
        ["<C-j>"] = "actions.down_and_scroll",
        ["<C-k>"] = "actions.up_and_scroll",
        
        -- Navegación avanzada
        ["{"] = "actions.prev_up",
        ["}"] = "actions.next_up",
        ["[["] = "actions.prev_up",
        ["]]"] = "actions.next_up",
        
        -- Control de plegado
        ["zr"] = "actions.tree_increase_fold_level",
        ["zR"] = "actions.tree_open_all",
        ["zm"] = "actions.tree_decrease_fold_level",
        ["zM"] = "actions.tree_close_all",
        ["zx"] = "actions.tree_sync_folds",
        ["zX"] = "actions.tree_sync_folds",
      },
      
      -- Lazy loading para mejor rendimiento
      lazy_load = true,
      
      -- Deshabilitar en tipos de archivo específicos
      disable_max_lines = 10000,
      disable_max_size = 2000000, -- 2MB
      
      -- Integración con telescope (si lo tienes instalado)
      on_attach = function(bufnr)
        -- Mapeos locales del buffer
        vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr, desc = "Símbolo anterior" })
        vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr, desc = "Símbolo siguiente" })
      end,
    })
    
    -- Atajos de teclado globales
    vim.keymap.set("n", "<leader>o", "<cmd>AerialToggle!<CR>", { desc = "Toggle Aerial (Outline)" })
    vim.keymap.set("n", "<leader>no", "<cmd>AerialNavToggle<CR>", { desc = "Toggle Aerial Nav" })
    
    -- Integración con Telescope (si está instalado)
    pcall(function()
      local telescope = require("telescope")
      telescope.load_extension("aerial")
      vim.keymap.set("n", "<leader>fo", "<cmd>Telescope aerial<CR>", { desc = "Find Symbols (Aerial)" })
    end)
  end,
}
