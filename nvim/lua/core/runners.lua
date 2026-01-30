-- ============================================================================
-- RUNNERS PARA PROYECTOS (Spring Boot, React Router 7, etc.)
-- Ejecuta aplicaciones en terminales dedicados sin contaminar variables del sistema
-- ============================================================================

local M = {}

-- Almacena las terminales activas por tipo
local terminals = {}

-- Verifica si existe un archivo en el directorio actual o sus padres
local function find_project_root(markers)
    local cwd = vim.fn.getcwd()
    for _, marker in ipairs(markers) do
        if vim.fn.filereadable(cwd .. "/" .. marker) == 1 or vim.fn.isdirectory(cwd .. "/" .. marker) == 1 then
            return cwd
        end
    end
    return nil
end

-- Verifica si existe un archivo .env en el proyecto
local function has_env_file()
    local cwd = vim.fn.getcwd()
    return vim.fn.filereadable(cwd .. "/.env") == 1
end

-- ============================================================================
-- SPRING BOOT RUNNER
-- ============================================================================
function M.spring_boot_run()
    local Terminal = require("toggleterm.terminal").Terminal

    -- Verifica que sea un proyecto Spring Boot
    local root = find_project_root({ "pom.xml", "build.gradle", "mvnw", "gradlew" })
    if not root then
        vim.notify("No se encontro proyecto Maven/Gradle en el directorio actual", vim.log.levels.ERROR)
        return
    end

    -- Determina el comando (Maven o Gradle)
    local cmd
    local has_mvnw = vim.fn.filereadable(root .. "/mvnw") == 1
    local has_gradlew = vim.fn.filereadable(root .. "/gradlew") == 1
    local has_pom = vim.fn.filereadable(root .. "/pom.xml") == 1

    if has_mvnw then
        cmd = "./mvnw spring-boot:run"
    elseif has_gradlew then
        cmd = "./gradlew bootRun"
    elseif has_pom then
        cmd = "mvn spring-boot:run"
    else
        cmd = "gradle bootRun"
    end

    -- Si hay .env, carga las variables solo para este proceso
    if has_env_file() then
        -- Usa env para cargar las variables sin exportarlas al sistema
        -- El comando lee el .env y las pasa como variables de entorno solo al proceso hijo
        cmd = string.format([[bash -c 'set -a; source .env; set +a; %s']], cmd)
    end

    -- Cierra terminal anterior si existe
    if terminals.spring and terminals.spring:is_open() then
        terminals.spring:close()
    end

    -- Crea nueva terminal
    terminals.spring = Terminal:new({
        cmd = cmd,
        dir = root,
        direction = "horizontal",
        close_on_exit = false,
        on_open = function(term)
            vim.notify("Spring Boot iniciando...", vim.log.levels.INFO)
        end,
        on_exit = function(term, job, exit_code, name)
            if exit_code == 0 then
                vim.notify("Spring Boot detenido correctamente", vim.log.levels.INFO)
            else
                vim.notify("Spring Boot termino con codigo: " .. exit_code, vim.log.levels.WARN)
            end
        end,
    })

    terminals.spring:toggle()
end

function M.spring_boot_stop()
    if terminals.spring then
        if terminals.spring:is_open() then
            -- Envia Ctrl+C para detener gracefully
            terminals.spring:send("\x03")
            vim.defer_fn(function()
                if terminals.spring:is_open() then
                    terminals.spring:close()
                end
            end, 1000)
            vim.notify("Deteniendo Spring Boot...", vim.log.levels.INFO)
        else
            vim.notify("Spring Boot no esta ejecutandose", vim.log.levels.WARN)
        end
    else
        vim.notify("No hay instancia de Spring Boot activa", vim.log.levels.WARN)
    end
end

function M.spring_boot_toggle()
    if terminals.spring then
        terminals.spring:toggle()
    else
        vim.notify("No hay terminal de Spring Boot. Usa <M-s> para iniciar.", vim.log.levels.INFO)
    end
end

-- ============================================================================
-- REACT ROUTER 7 RUNNER
-- ============================================================================
function M.react_router_run()
    local Terminal = require("toggleterm.terminal").Terminal

    -- Verifica que sea un proyecto React Router
    local root = find_project_root({ "package.json", "react-router.config.ts", "react-router.config.js" })
    if not root then
        vim.notify("No se encontro proyecto Node.js en el directorio actual", vim.log.levels.ERROR)
        return
    end

    -- Verifica que tenga react-router en package.json
    local package_json_path = root .. "/package.json"
    if vim.fn.filereadable(package_json_path) == 1 then
        local content = table.concat(vim.fn.readfile(package_json_path), "\n")
        if not content:match("react%-router") and not content:match("@react%-router") then
            vim.notify("Este proyecto no parece usar React Router", vim.log.levels.WARN)
        end
    end

    -- Comando: elimina .react-router y ejecuta bun dev --host
    local cmd = "rm -rf .react-router && bun dev --host"

    -- Cierra terminal anterior si existe
    if terminals.react and terminals.react:is_open() then
        terminals.react:close()
    end

    -- Crea nueva terminal
    terminals.react = Terminal:new({
        cmd = cmd,
        dir = root,
        direction = "horizontal",
        close_on_exit = false,
        on_open = function(term)
            vim.notify("React Router 7 iniciando (limpiando .react-router)...", vim.log.levels.INFO)
        end,
        on_exit = function(term, job, exit_code, name)
            if exit_code == 0 then
                vim.notify("React Router 7 detenido correctamente", vim.log.levels.INFO)
            else
                vim.notify("React Router 7 termino con codigo: " .. exit_code, vim.log.levels.WARN)
            end
        end,
    })

    terminals.react:toggle()
end

function M.react_router_stop()
    if terminals.react then
        if terminals.react:is_open() then
            -- Envia Ctrl+C para detener gracefully
            terminals.react:send("\x03")
            vim.defer_fn(function()
                if terminals.react:is_open() then
                    terminals.react:close()
                end
            end, 1000)
            vim.notify("Deteniendo React Router 7...", vim.log.levels.INFO)
        else
            vim.notify("React Router 7 no esta ejecutandose", vim.log.levels.WARN)
        end
    else
        vim.notify("No hay instancia de React Router 7 activa", vim.log.levels.WARN)
    end
end

function M.react_router_toggle()
    if terminals.react then
        terminals.react:toggle()
    else
        vim.notify("No hay terminal de React Router. Usa <M-r> para iniciar.", vim.log.levels.INFO)
    end
end

-- ============================================================================
-- COMANDOS VIM
-- ============================================================================
vim.api.nvim_create_user_command("SpringBootRun", M.spring_boot_run, { desc = "Ejecutar Spring Boot con .env" })
vim.api.nvim_create_user_command("SpringBootStop", M.spring_boot_stop, { desc = "Detener Spring Boot" })
vim.api.nvim_create_user_command("SpringBootToggle", M.spring_boot_toggle, { desc = "Mostrar/Ocultar terminal Spring" })

vim.api.nvim_create_user_command("ReactRouterRun", M.react_router_run,
    { desc = "Ejecutar React Router 7 (bun dev --host)" })
vim.api.nvim_create_user_command("ReactRouterStop", M.react_router_stop, { desc = "Detener React Router 7" })
vim.api.nvim_create_user_command("ReactRouterToggle", M.react_router_toggle, { desc = "Mostrar/Ocultar terminal React" })

return M
