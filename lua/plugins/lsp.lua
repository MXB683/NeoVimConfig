return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup({
                ui = {
                    border = "rounded",
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗",
                    },
                },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            -- Keybinds when LSP attaches
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspKeybinds", { clear = true }),
                callback = function(event)
                    local map = function(keys, func, desc)
                        vim.keymap.set("n", keys, func, { buffer = event.buf, desc = desc })
                    end

                    map("gd", vim.lsp.buf.definition,        "Go to definition")
                    map("gD", vim.lsp.buf.declaration,       "Go to declaration")
                    map("gr", vim.lsp.buf.references,        "References")
                    map("gi", vim.lsp.buf.implementation,    "Go to implementation")
                    map("K",  vim.lsp.buf.hover,             "Hover docs")
                    map("<leader>rn", vim.lsp.buf.rename,    "Rename symbol")
                    map("<M-CR>", vim.lsp.buf.code_action, "Code action")
                    map("<leader>d",  vim.diagnostic.open_float, "Line diagnostics")
                    map("[d", vim.diagnostic.goto_prev,      "Prev diagnostic")
                    map("]d", vim.diagnostic.goto_next,      "Next diagnostic")
                end,
            })

            vim.diagnostic.config({
                virtual_text = true,
                signs = true,
                underline = true,
                update_in_insert = false,
                float = {
                    border = "rounded",
                    source = true,
                },
            })

            -- Native 0.11 LSP config
            vim.lsp.config("clangd", {
                cmd = {
                    "clangd",
                    "--background-index",
                    "--clang-tidy",
                    "--header-insertion=iwyu",
                    "--completion-style=detailed",
                    "--fallback-style=llvm",
                },
                filetypes = { "c", "cpp", "objc", "objcpp" },
                root_markers = { "compile_commands.json", "compile_flags.txt", ".git" },
            })

            vim.lsp.enable("clangd")
        end,
    },
}
