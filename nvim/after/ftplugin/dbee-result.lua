-- ============================================================================
-- NVIM-DBEE RESULT: Configuración visual para resultados de MongoDB
-- Auto-ejecutado cuando se abre un buffer dbee-result
-- ============================================================================

-- Establecer filetype a JSON para syntax highlighting automático
vim.bo.filetype = "json"

-- Habilitar treesitter para este buffer
vim.treesitter.start()

-- Configuración de indentación para JSON
vim.bo.shiftwidth = 2
vim.bo.tabstop = 2
vim.bo.expandtab = true

-- Resaltado personalizado para operadores MongoDB (claves que empiezan con $)
vim.fn.matchadd('DbeeMongoOperator', '"\\$[^"]*"')

-- Resaltado para ObjectIDs de MongoDB
vim.fn.matchadd('DbeeMongoObjectId', '"[a-f0-9]\\{24\\}"')

-- Definir los grupos de resaltado si no existen
local highlights = {
    DbeeMongoOperator = { link = '@operator.mongodb' },
    DbeeMongoObjectId = { link = '@string.special.mongodb' },
}

for group, opts in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, opts)
end
