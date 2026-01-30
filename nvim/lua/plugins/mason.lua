return {
  "williamboman/mason.nvim",
  config = function()
    require("mason").setup({
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗"
        }
      }
    })
    
    vim.defer_fn(function()
      local ok, mason_registry = pcall(require, "mason-registry")
      if not ok then
        return
      end
      
      local ensure_installed = {
        "jdtls",
        "java-debug-adapter",
        "java-test",
        "lua-language-server",
        "json-lsp",
        "yaml-language-server",
        "lemminx",
        "typescript-language-server",
        "eslint-lsp",
        "prettier",
        "vtsls",
      }
      
      for _, tool in ipairs(ensure_installed) do
        if mason_registry.has_package(tool) then
          local p = mason_registry.get_package(tool)
          if not p:is_installed() then
            vim.notify("Installing " .. tool, vim.log.levels.INFO)
            p:install()
          end
        end
      end
    end, 500)
  end,
}
