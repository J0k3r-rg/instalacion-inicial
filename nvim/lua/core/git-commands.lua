-- ============================================================================
-- Comandos Git interactivos
-- Funciones para operaciones comunes de Git con feedback visual
-- ============================================================================

local M = {}

-- Función helper para ejecutar comandos git y mostrar resultado
local function run_git_command(cmd, success_msg, error_msg)
    local output = vim.fn.system(cmd)
    local exit_code = vim.v.shell_error
    
    if exit_code == 0 then
        vim.notify(success_msg or "Comando ejecutado exitosamente", vim.log.levels.INFO)
        return true, output
    else
        vim.notify((error_msg or "Error al ejecutar comando") .. "\n" .. output, vim.log.levels.ERROR)
        return false, output
    end
end

-- Git Add - Agregar archivos al staging
function M.add()
    -- Obtener lista de archivos modificados
    local files = vim.fn.systemlist("git status --porcelain")
    
    if #files == 0 then
        vim.notify("No hay archivos para agregar", vim.log.levels.WARN)
        return
    end
    
    -- Crear opciones para vim.ui.select
    local options = { "." }  -- Opción para agregar todo
    for _, file in ipairs(files) do
        -- Extraer el nombre del archivo (después del status)
        local filename = file:match("%s+(.+)$")
        if filename then
            table.insert(options, filename)
        end
    end
    
    vim.ui.select(options, {
        prompt = "Selecciona archivos para agregar (. = todos):",
        format_item = function(item)
            if item == "." then
                return "• Todos los archivos"
            end
            return "  " .. item
        end
    }, function(choice)
        if not choice then return end
        
        local cmd = "git add " .. vim.fn.shellescape(choice)
        run_git_command(cmd, "✓ Archivos agregados: " .. choice)
    end)
end

-- Git Commit - Hacer commit con mensaje
function M.commit()
    vim.ui.input({
        prompt = "Mensaje del commit: ",
    }, function(message)
        if not message or message == "" then
            vim.notify("Commit cancelado - sin mensaje", vim.log.levels.WARN)
            return
        end
        
        local cmd = "git commit -m " .. vim.fn.shellescape(message)
        run_git_command(cmd, "✓ Commit realizado: " .. message)
    end)
end

-- Git Pull - Traer cambios del remoto
function M.pull()
    vim.notify("Ejecutando git pull...", vim.log.levels.INFO)
    
    local cmd = "git pull"
    local success, output = run_git_command(cmd, "✓ Pull completado exitosamente")
    
    if success then
        -- Refrescar buffers en caso de cambios
        vim.cmd("checktime")
    end
end

-- Git Push - Enviar cambios al remoto
function M.push()
    -- Primero verificar si hay algo para pushear
    local status = vim.fn.system("git status")
    
    if status:match("nothing to commit") and status:match("up to date") then
        vim.notify("No hay cambios para pushear", vim.log.levels.WARN)
        return
    end
    
    vim.notify("Ejecutando git push...", vim.log.levels.INFO)
    
    local cmd = "git push"
    run_git_command(cmd, "✓ Push completado exitosamente")
end

-- Git New Branch - Crear nueva rama y hacer checkout
function M.new_branch()
    vim.ui.input({
        prompt = "Nombre de la nueva rama: ",
    }, function(branch_name)
        if not branch_name or branch_name == "" then
            vim.notify("Operación cancelada - sin nombre de rama", vim.log.levels.WARN)
            return
        end
        
        -- Validar nombre de rama (no espacios, caracteres especiales básicos)
        if not branch_name:match("^[a-zA-Z0-9/_-]+$") then
            vim.notify("Nombre de rama inválido. Usa solo letras, números, /, - y _", vim.log.levels.ERROR)
            return
        end
        
        local cmd = "git checkout -b " .. vim.fn.shellescape(branch_name)
        run_git_command(cmd, "✓ Rama creada y checkout realizado: " .. branch_name)
    end)
end

-- Git Checkout - Cambiar a otra rama
function M.checkout()
    -- Obtener lista de ramas
    local branches_output = vim.fn.systemlist("git branch --all")
    
    if #branches_output == 0 then
        vim.notify("No se encontraron ramas", vim.log.levels.ERROR)
        return
    end
    
    -- Limpiar y formatear ramas
    local branches = {}
    local current_branch = nil
    
    for _, branch in ipairs(branches_output) do
        -- Quitar el asterisco y espacios
        local clean_branch = branch:gsub("^%*%s+", ""):gsub("^%s+", "")
        
        -- Ignorar ramas remotas duplicadas y HEAD
        if not clean_branch:match("^remotes/") and not clean_branch:match("HEAD") then
            table.insert(branches, clean_branch)
            
            -- Marcar rama actual
            if branch:match("^%*") then
                current_branch = clean_branch
            end
        end
    end
    
    if #branches == 0 then
        vim.notify("No hay ramas disponibles", vim.log.levels.ERROR)
        return
    end
    
    vim.ui.select(branches, {
        prompt = "Selecciona rama para checkout:",
        format_item = function(item)
            if item == current_branch then
                return "● " .. item .. " (actual)"
            end
            return "  " .. item
        end
    }, function(choice)
        if not choice then return end
        
        if choice == current_branch then
            vim.notify("Ya estás en la rama: " .. choice, vim.log.levels.WARN)
            return
        end
        
        local cmd = "git checkout " .. vim.fn.shellescape(choice)
        local success = run_git_command(cmd, "✓ Checkout realizado a: " .. choice)
        
        if success then
            -- Refrescar buffers
            vim.cmd("checktime")
        end
    end)
end

-- Git Status - Ver estado actual (abre en buffer flotante)
function M.status()
    local status = vim.fn.systemlist("git status")
    
    if vim.v.shell_error ~= 0 then
        vim.notify("Error al obtener git status", vim.log.levels.ERROR)
        return
    end
    
    -- Crear buffer flotante para mostrar status
    local buf = vim.api.nvim_create_buf(false, true)
    local width = math.ceil(vim.o.columns * 0.6)
    local height = math.ceil(vim.o.lines * 0.6)
    
    local opts = {
        style = "minimal",
        relative = "editor",
        width = width,
        height = height,
        row = math.ceil((vim.o.lines - height) / 2),
        col = math.ceil((vim.o.columns - width) / 2),
        border = "rounded",
        title = " Git Status ",
        title_pos = "center"
    }
    
    local win = vim.api.nvim_open_win(buf, true, opts)
    
    -- Agregar contenido
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, status)
    vim.api.nvim_buf_set_option(buf, 'modifiable', false)
    vim.api.nvim_buf_set_option(buf, 'filetype', 'git')
    
    -- Mapear 'q' para cerrar
    vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':close<CR>', 
        { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', ':close<CR>', 
        { noremap = true, silent = true })
end

-- Git Commit and Push - Add, commit y push en una operación
function M.commit_and_push()
    vim.ui.input({
        prompt = "Mensaje del commit: ",
    }, function(message)
        if not message or message == "" then
            vim.notify("Operación cancelada - sin mensaje", vim.log.levels.WARN)
            return
        end
        
        -- 1. Git add .
        vim.notify("Agregando archivos...", vim.log.levels.INFO)
        local add_success = run_git_command("git add .", "✓ Archivos agregados")
        
        if not add_success then
            return
        end
        
        -- 2. Git commit
        vim.notify("Realizando commit...", vim.log.levels.INFO)
        local commit_cmd = "git commit -m " .. vim.fn.shellescape(message)
        local commit_success = run_git_command(commit_cmd, "✓ Commit realizado: " .. message)
        
        if not commit_success then
            return
        end
        
        -- 3. Git push
        vim.notify("Enviando cambios al remoto...", vim.log.levels.INFO)
        local push_success = run_git_command("git push", "✓ Push completado exitosamente")
        
        if push_success then
            vim.notify("✓ Operación completa: add + commit + push", vim.log.levels.INFO)
        end
    end)
end

-- Git Restore - Deshacer cambios de archivos
function M.restore()
    -- Obtener lista de archivos modificados
    local files = vim.fn.systemlist("git status --porcelain")
    
    if #files == 0 then
        vim.notify("No hay archivos modificados para revertir", vim.log.levels.WARN)
        return
    end
    
    -- Filtrar solo archivos modificados (no nuevos)
    local modified_files = {}
    for _, file in ipairs(files) do
        local status = file:sub(1, 2)
        local filename = file:match("%s+(.+)$")
        
        -- M = modified, MM = modified in both index and working tree
        -- D = deleted, etc.
        if filename and (status:match("M") or status:match("D") or status:match("A")) then
            table.insert(modified_files, {
                name = filename,
                status = status
            })
        end
    end
    
    if #modified_files == 0 then
        vim.notify("No hay archivos modificados para revertir", vim.log.levels.WARN)
        return
    end
    
    -- Crear opciones para el selector
    local options = {}
    for _, file in ipairs(modified_files) do
        table.insert(options, file.name)
    end
    
    vim.ui.select(options, {
        prompt = "⚠️  Selecciona archivo para REVERTIR cambios (se perderán los cambios):",
        format_item = function(item)
            -- Encontrar el status del archivo
            local status = ""
            for _, file in ipairs(modified_files) do
                if file.name == item then
                    status = file.status
                    break
                end
            end
            
            -- Formato con indicador de estado
            local indicator = ""
            if status:match("M") then
                indicator = "● "  -- Modificado
            elseif status:match("D") then
                indicator = "✗ "  -- Eliminado
            elseif status:match("A") then
                indicator = "✚ "  -- Agregado
            end
            
            return indicator .. item
        end
    }, function(choice)
        if not choice then return end
        
        -- Confirmar antes de revertir
        vim.ui.input({
            prompt = "⚠️  ¿Estás seguro de revertir '" .. choice .. "'? (escribe 'si' para confirmar): ",
        }, function(confirm)
            if not confirm or confirm:lower() ~= "si" then
                vim.notify("Operación cancelada", vim.log.levels.INFO)
                return
            end
            
            -- Ejecutar git restore
            local cmd = "git restore " .. vim.fn.shellescape(choice)
            local success = run_git_command(cmd, "✓ Cambios revertidos en: " .. choice)
            
            if success then
                -- Refrescar el buffer si está abierto
                vim.cmd("checktime")
                
                -- Si el archivo está abierto, recargar
                for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                    local buf_name = vim.api.nvim_buf_get_name(buf)
                    if buf_name:match(choice .. "$") then
                        vim.api.nvim_buf_call(buf, function()
                            vim.cmd("edit!")
                        end)
                    end
                end
            end
        end)
    end)
end

return M
