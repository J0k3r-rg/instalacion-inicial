return {
  "rcarriga/nvim-notify",
  lazy = false,
  priority = 1000,
  opts = {
    background_colour = "#000000",  -- Valor hexadecimal RGB según docs
    stages = "fade_in_slide_out",
    timeout = 5000,
    max_height = function()
      return math.floor(vim.o.lines * 0.75)
    end,
    max_width = function()
      return math.floor(vim.o.columns * 0.75)
    end,
  },
  config = function(_, opts)
    local notify = require("notify")
    notify.setup(opts)
    vim.notify = notify
  end,
}
