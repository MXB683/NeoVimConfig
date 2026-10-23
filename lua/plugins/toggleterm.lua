return {
    "akinsho/toggleterm.nvim",
    config = function()
        require("toggleterm").setup({
            size = 20,
            open_mapping = [[<C-\>]],
            direction = "float",
            float_opts = {
                border = "curved",
                width = function()
                    return math.floor(vim.o.columns * 0.75)
                end,
                height = function()
                    return math.floor(vim.o.lines * 0.75)
                end,
                winblend = 10,
            },
            shade_terminals = true,
            start_in_insert = true,
            persist_mode = true,
        })

        local Terminal = require("toggleterm.terminal").Terminal

        local function run_file()
            require("utils.code_running").run(Terminal)
        end

        vim.keymap.set("n", "<F9>", run_file, { desc = "Run project/file" })

        -- Terminal mode: Esc to go back to normal mode inside the generic terminal
        vim.keymap.set("t", "<C-x>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
    end,
}
