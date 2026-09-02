return {
    "stevearc/conform.nvim",
    config = function()
        local conform = require("conform")

        conform.setup({
            formatters_by_ft = {
                c   = { "clang_format" },
                cpp = { "clang_format" },
                python = { "black" },
            },
            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = true,
            },
            formatters = {
                clang_format = {
                    prepend_args = {
                        "--style={BasedOnStyle: LLVM, IndentWidth: 4, ColumnLimit: 120}",
                    },
                },
            },
        })

        -- Manual format keybind
        vim.keymap.set({ "n", "v" }, "<leader>f", function()
            conform.format({
                lsp_fallback = true,
                timeout_ms = 500,
            })
        end, { desc = "Format file" })
    end,
}
