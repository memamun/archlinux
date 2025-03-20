local M = {}

local initialized = false

function M.setup()
    if initialized then
        return
    end

    -- Add sign definitions with fallback icons
    local signs = {
        { name = "DiagnosticSignError", text = "✘" },
        { name = "DiagnosticSignWarn", text = "⚠" },
        { name = "DiagnosticSignHint", text = "⚡" },
        { name = "DiagnosticSignInfo", text = "ℹ" },
    }

    -- Define fallback icons
    for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, {
            text = sign.text,
            texthl = sign.name,
            numhl = sign.name
        })
    end

    -- Configure diagnostic display
    vim.diagnostic.config({
        signs = true,
        update_in_insert = false,
        underline = true,
        severity_sort = true,
        virtual_text = {
            prefix = '●', -- Use a simple dot as fallback
            source = true,
        },
    })

    vim.notify("Starting LSP configuration...", vim.log.levels.INFO)

    -- Enhanced error handling for module loading
    local status_ok, err = pcall(function()
        -- Simpler plugin availability check
        local function is_plugin_available(plugin_name)
            local ok, _ = pcall(require, plugin_name)
            vim.notify(string.format("Checking plugin %s: %s", plugin_name, ok), vim.log.levels.DEBUG)
            return ok
        end

        -- First try to load lspconfig directly
        local lspconfig_ok, lspconfig = pcall(require, 'lspconfig')
        if not lspconfig_ok then
            error("Could not load nvim-lspconfig. Please ensure it's installed and loaded properly.")
            return
        end

        -- Then try other required plugins
        local required_plugins = {
            'cmp',
            'cmp_nvim_lsp'
        }

        for _, plugin in ipairs(required_plugins) do
            if not is_plugin_available(plugin) then
                error(string.format("Required plugin '%s' is not available", plugin))
                return
            end
        end

        -- Initialize modules directly
        local cmp = require('cmp')
        local cmp_nvim_lsp = require('cmp_nvim_lsp')

        -- Setup nvim-cmp
        cmp.setup({
            mapping = cmp.mapping.preset.insert({
                ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'buffer' },
                { name = 'path' },
            })
        })

        -- LSP setup with enhanced error checking
        local capabilities = cmp_nvim_lsp.default_capabilities()
        
        -- Server configurations with validation
        local servers = { 'pyright', 'typescript' }  -- Changed from tsserver to typescript
        for _, lsp in pairs(servers) do
            if (lspconfig[lsp]) then
                local config = {
                    capabilities = capabilities,
                    on_init = function(client)
                        vim.notify(string.format("LSP Server %s initialized", lsp), vim.log.levels.INFO)
                    end,
                    on_attach = function(client, bufnr)
                        vim.notify(string.format("LSP Server %s attached to buffer", lsp), vim.log.levels.INFO)
                    end
                }

                if lsp == 'typescript' then
                    config.root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json")
                    config.single_file_support = true
                    config.cmd = { "typescript-language-server", "--stdio" }
                    config.filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" }
                end

                lspconfig[lsp].setup(config)
            else
                vim.notify(string.format("LSP Server %s not available", lsp), vim.log.levels.WARN)
            end
        end
    end)

    if not status_ok then
        vim.notify(string.format("LSP setup failed: %s", tostring(err)), vim.log.levels.ERROR)
        return
    end

    initialized = true
    vim.notify("LSP configuration completed successfully", vim.log.levels.INFO)
end

return M
