-- ============================================================================
-- COMANDOS DE DOCKER - Gestión de contenedores
-- ============================================================================

local M = {}

-- Ruta del docker-compose.yml
local DOCKER_COMPOSE_PATH = "~/SIAS/docker-compose.yml"

-- Función auxiliar para ejecutar comandos de docker en un terminal flotante
local function execute_docker_command(cmd, title)
  local Terminal = require("toggleterm.terminal").Terminal
  
  local docker_cmd = Terminal:new({
    cmd = cmd,
    dir = vim.fn.expand("~/SIAS"),
    direction = "float",
    close_on_exit = false,
    on_open = function(term)
      vim.cmd("startinsert!")
      vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
    end,
  })
  
  docker_cmd:toggle()
end

-- ============================================================================
-- COMANDOS PRINCIPALES
-- ============================================================================

-- Levantar contenedores (docker-compose up)
function M.compose_up()
  vim.notify("🐳 Levantando contenedores de Docker...", vim.log.levels.INFO)
  execute_docker_command(
    "docker-compose -f " .. DOCKER_COMPOSE_PATH .. " up -d && echo '\n✅ Contenedores levantados correctamente' && echo 'Presiona q para cerrar'",
    "Docker Compose Up"
  )
end

-- Detener contenedores (docker-compose down)
function M.compose_down()
  vim.notify("🐳 Deteniendo contenedores de Docker...", vim.log.levels.INFO)
  execute_docker_command(
    "docker-compose -f " .. DOCKER_COMPOSE_PATH .. " down && echo '\n✅ Contenedores detenidos correctamente' && echo 'Presiona q para cerrar'",
    "Docker Compose Down"
  )
end

-- Ver logs de los contenedores
function M.compose_logs()
  vim.notify("🐳 Mostrando logs de Docker...", vim.log.levels.INFO)
  execute_docker_command(
    "docker-compose -f " .. DOCKER_COMPOSE_PATH .. " logs -f",
    "Docker Compose Logs"
  )
end

-- Ver estado de los contenedores
function M.compose_ps()
  vim.notify("🐳 Mostrando estado de contenedores...", vim.log.levels.INFO)
  execute_docker_command(
    "docker-compose -f " .. DOCKER_COMPOSE_PATH .. " ps && echo '\nPresiona q para cerrar'",
    "Docker Compose Status"
  )
end

return M
