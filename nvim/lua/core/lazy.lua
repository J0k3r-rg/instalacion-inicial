local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Configuración limpia: solo carga lo que tú pongas en la carpeta plugins
require("lazy").setup({
  spec = {
    { import = "plugins" }, -- Esto carga tus archivos en lua/plugins/
  },
  install = { colorscheme = { "rose-pine" } }, -- Tu nuevo tema
  checker = { enabled = true },
})
