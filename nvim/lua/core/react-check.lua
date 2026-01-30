local M = {}

function M.check_installation()
  local results = {}
  
  table.insert(results, "=== React Router 7 / TypeScript Installation Check ===\n")
  
  local ok_registry, mason_registry = pcall(require, "mason-registry")
  if not ok_registry then
    table.insert(results, "❌ Mason registry not available")
    vim.notify(table.concat(results, "\n"), vim.log.levels.ERROR)
    return
  end
  
  local tools = {
    { name = "typescript-language-server", display = "TypeScript LSP" },
    { name = "eslint-lsp", display = "ESLint LSP" },
    { name = "prettier", display = "Prettier" },
    { name = "vtsls", display = "VTSLS (Alternative TS Server)" },
  }
  
  for _, tool in ipairs(tools) do
    if mason_registry.has_package(tool.name) then
      local pkg = mason_registry.get_package(tool.name)
      if pkg:is_installed() then
        table.insert(results, "✅ " .. tool.display .. " is installed")
      else
        table.insert(results, "❌ " .. tool.display .. " is NOT installed")
        table.insert(results, "   Run :Mason and install '" .. tool.name .. "'")
      end
    else
      table.insert(results, "⚠️  " .. tool.display .. " package not found in Mason")
    end
  end
  
  table.insert(results, "\n=== Node.js Check ===")
  local node_version = vim.fn.system("node --version 2>&1")
  if vim.v.shell_error == 0 then
    table.insert(results, "✅ Node.js: " .. vim.trim(node_version))
  else
    table.insert(results, "❌ Node.js not found in PATH")
  end
  
  local npm_version = vim.fn.system("npm --version 2>&1")
  if vim.v.shell_error == 0 then
    table.insert(results, "✅ npm: " .. vim.trim(npm_version))
  else
    table.insert(results, "❌ npm not found in PATH")
  end
  
  table.insert(results, "\n=== Project Check ===")
  local cwd = vim.fn.getcwd()
  
  if vim.fn.filereadable(cwd .. '/package.json') == 1 then
    table.insert(results, "✅ package.json found")
    
    local package_json = vim.fn.readfile(cwd .. '/package.json')
    local content = table.concat(package_json, '\n')
    
    if content:match('react%-router') then
      table.insert(results, "✅ react-router dependency found")
    else
      table.insert(results, "⚠️  react-router not found in package.json")
    end
  else
    table.insert(results, "⚠️  package.json not found (not in a Node.js project)")
  end
  
  if vim.fn.filereadable(cwd .. '/tsconfig.json') == 1 then
    table.insert(results, "✅ tsconfig.json found")
    
    local tsconfig = vim.fn.readfile(cwd .. '/tsconfig.json')
    local ts_content = table.concat(tsconfig, '\n')
    
    if ts_content:match('%.react%-router/types') then
      table.insert(results, "✅ tsconfig.json configured for React Router 7")
    else
      table.insert(results, "⚠️  tsconfig.json needs React Router 7 configuration")
      table.insert(results, "   Run :ReactRouterSetup for details")
    end
  else
    table.insert(results, "⚠️  tsconfig.json not found")
  end
  
  if vim.fn.isdirectory(cwd .. '/.react-router') == 1 then
    table.insert(results, "✅ .react-router directory exists")
  else
    table.insert(results, "⚠️  .react-router directory not found (run dev server first)")
  end
  
  table.insert(results, "\n=== LSP Status ===")
  local active_clients = vim.lsp.get_clients({ bufnr = 0 })
  if #active_clients > 0 then
    for _, client in ipairs(active_clients) do
      table.insert(results, "✅ Active LSP: " .. client.name)
    end
  else
    table.insert(results, "⚠️  No LSP clients active in current buffer")
  end
  
  table.insert(results, "\n=== Treesitter Check ===")
  local ok_ts, ts_parsers = pcall(require, "nvim-treesitter.parsers")
  if ok_ts and ts_parsers.has_parser then
    local langs = { "typescript", "tsx", "javascript", "jsx" }
    for _, lang in ipairs(langs) do
      if ts_parsers.has_parser(lang) then
        table.insert(results, "✅ Treesitter parser: " .. lang)
      else
        table.insert(results, "❌ Treesitter parser missing: " .. lang)
        table.insert(results, "   Run :TSInstall " .. lang)
      end
    end
  else
    table.insert(results, "⚠️  Treesitter check skipped (install parsers with :TSInstall)")
  end
  
  vim.notify(table.concat(results, "\n"), vim.log.levels.INFO)
end

vim.api.nvim_create_user_command('ReactCheckInstallation', function()
  M.check_installation()
end, { desc = 'Check React Router 7 installation' })

return M
