return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
        local capabilities = _G.lsp_capabilities or require("cmp_nvim_lsp").default_capabilities()

        capabilities.textDocument.completion.completionItem.snippetSupport = true
        capabilities.textDocument.completion.completionItem.resolveSupport = {
            properties = {
                'documentation',
                'detail',
                'additionalTextEdits',
            }
        }

        local on_attach = function(client, bufnr)
            -- Atajos de teclado LSP centralizados en lua/core/keymaps.lua
        end

        -- Usar vim.lsp.config en lugar de lspconfig (nueva API de nvim 0.11+)
        vim.lsp.config('ts_ls', {
            on_attach = on_attach,
            capabilities = capabilities,
            settings = {
                typescript = {
                    inlayHints = {
                        includeInlayParameterNameHints = 'all',
                        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                        includeInlayFunctionParameterTypeHints = true,
                        includeInlayVariableTypeHints = true,
                        includeInlayPropertyDeclarationTypeHints = true,
                        includeInlayFunctionLikeReturnTypeHints = true,
                        includeInlayEnumMemberValueHints = true,
                    },
                    suggest = {
                        includeCompletionsForModuleExports = true,
                        includeAutomaticOptionalChainCompletions = true,
                    },
                    preferences = {
                        importModuleSpecifier = 'relative',
                        includePackageJsonAutoImports = 'on',
                    },
                },
                javascript = {
                    inlayHints = {
                        includeInlayParameterNameHints = 'all',
                        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                        includeInlayFunctionParameterTypeHints = true,
                        includeInlayVariableTypeHints = true,
                        includeInlayPropertyDeclarationTypeHints = true,
                        includeInlayFunctionLikeReturnTypeHints = true,
                        includeInlayEnumMemberValueHints = true,
                    },
                    suggest = {
                        includeCompletionsForModuleExports = true,
                        includeAutomaticOptionalChainCompletions = true,
                    },
                },
            },
        })

        vim.lsp.config('eslint', {
            on_attach = on_attach,
            capabilities = capabilities,
            settings = {
                format = true,
                validate = 'on',
                run = 'onType',
            },
        })

        vim.lsp.config('lua_ls', {
            on_attach = on_attach,
            capabilities = capabilities,
        })

        vim.lsp.config('jsonls', {
            on_attach = on_attach,
            capabilities = capabilities,
        })

        vim.lsp.config('yamlls', {
            on_attach = on_attach,
            capabilities = capabilities,
        })

        vim.lsp.config('lemminx', {
            on_attach = on_attach,
            capabilities = capabilities,
        })

        -- Activar los servidores LSP (nueva API de nvim 0.11+)
        vim.lsp.enable('ts_ls')
        vim.lsp.enable('eslint')
        vim.lsp.enable('lua_ls')
        vim.lsp.enable('jsonls')
        vim.lsp.enable('yamlls')
        vim.lsp.enable('lemminx')
    end,
}
