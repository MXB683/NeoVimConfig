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
                    return math.floor(vim.o.columns * 0.85)
                end,
                height = function()
                    return math.floor(vim.o.lines * 0.85)
                end,
                winblend = 10,
            },
            shade_terminals = true,
            start_in_insert = true,
            persist_mode = true,
        })

        -- Helpers
        local Terminal = require("toggleterm.terminal").Terminal

        -- Generic floating terminal toggle: Ctrl+\
        -- (already handled by open_mapping above)

        -- Run current C/C++ file
        local function run_c_file()
            vim.cmd("wa")
            local file = vim.fn.expand("%:p")       -- full path
            local out  = vim.fn.expand("%:p:r")     -- path without extension
            local ft   = vim.bo.filetype

            if ft ~= "c" and ft ~= "cpp" then
                vim.notify("Not a C/C++ file", vim.log.levels.WARN)
                return
            end

            local compiler = ft == "c" and "gcc" or "g++"
            local cmd = string.format(
                "%s '%s' -o '%s' && echo '--- Running ---' && '%s'; echo '--- Exit code: '$?",
                compiler, file, out, out
            )

            local term = Terminal:new({
                cmd = cmd,
                direction = "float",
                float_opts = {
                    border = "curved",
                    width = function()
                        return math.floor(vim.o.columns * 0.85)
                    end,
                    height = function()
                        return math.floor(vim.o.lines * 0.85)
                    end,
                },
                close_on_exit = false,  -- keep open so you can read output
                on_open = function(term)
                    vim.cmd("startinsert!")
                    -- Esc closes the terminal window
                    vim.keymap.set("t", "<Esc>", function()
                        term:close()
                    end, { buffer = term.bufnr })
                end,
            })
            term:toggle()
        end

        vim.keymap.set("n", "<F9>", run_c_file, { desc = "Compile and run C/C++ file" })
        vim.keymap.set("n", "<leader>r", run_c_file, { desc = "Compile and run C/C++ file" })

        -- Terminal mode: Esc to go back to normal mode inside the generic terminal
        vim.keymap.set("t", "<C-x>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
    end,
}
