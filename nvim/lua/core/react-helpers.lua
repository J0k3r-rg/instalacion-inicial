local M = {}

function M.setup_react_router_project()
  local cwd = vim.fn.getcwd()
  
  local tsconfig_path = cwd .. '/tsconfig.json'
  if vim.fn.filereadable(tsconfig_path) == 0 then
    vim.notify("No tsconfig.json found in project root", vim.log.levels.WARN)
    return
  end
  
  local tsconfig = vim.fn.readfile(tsconfig_path)
  local content = table.concat(tsconfig, '\n')
  
  local needs_update = false
  if not content:match('%.react%-router/types') then
    needs_update = true
  end
  
  if needs_update then
    vim.notify("tsconfig.json needs React Router 7 configuration", vim.log.levels.INFO)
    vim.notify("Add to include: '.react-router/types/**/*'", vim.log.levels.INFO)
    vim.notify("Add to compilerOptions.rootDirs: ['.', './.react-router/types']", vim.log.levels.INFO)
  else
    vim.notify("tsconfig.json already configured for React Router 7", vim.log.levels.INFO)
  end
end

function M.check_react_router_types()
  local cwd = vim.fn.getcwd()
  local types_dir = cwd .. '/.react-router/types'
  
  if vim.fn.isdirectory(types_dir) == 1 then
    vim.notify("React Router types directory found: " .. types_dir, vim.log.levels.INFO)
    return true
  else
    vim.notify("React Router types not generated yet. Run your dev server first.", vim.log.levels.WARN)
    return false
  end
end

function M.open_react_router_config()
  local cwd = vim.fn.getcwd()
  local config_path = cwd .. '/react-router.config.ts'
  
  if vim.fn.filereadable(config_path) == 1 then
    vim.cmd('edit ' .. config_path)
  else
    vim.notify("react-router.config.ts not found", vim.log.levels.WARN)
  end
end

vim.api.nvim_create_user_command('ReactRouterSetup', function()
  M.setup_react_router_project()
end, { desc = 'Check React Router 7 project configuration' })

vim.api.nvim_create_user_command('ReactRouterCheckTypes', function()
  M.check_react_router_types()
end, { desc = 'Check if React Router types are generated' })

vim.api.nvim_create_user_command('ReactRouterConfig', function()
  M.open_react_router_config()
end, { desc = 'Open react-router.config.ts' })

return M
