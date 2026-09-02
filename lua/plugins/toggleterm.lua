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

        local runners = {
            c = {
                compile = function(file)
                    local out = file:match("(.+)%..+$")
                    return string.format("gcc '%s' -o '%s'", file, out), out
                end,
                run = function(_, out)
                    return string.format("'%s'", out)
                end,
            },
            cpp = {
                compile = function(file)
                    local out = file:match("(.+)%..+$")
                    return string.format("g++ '%s' -o '%s'", file, out), out
                end,
                run = function(_, out)
                    return string.format("'%s'", out)
                end,
            },
            python = {
                compile = nil, -- interpreted, no compile step
                run = function(file, _)
                    -- use venv python if available, fall back to system
                    local venv = vim.fn.getcwd() .. "/.venv/bin/python3"
                    local python = vim.fn.filereadable(venv) == 1 and venv or "python3"
                    return string.format("'%s' '%s'", python, file)
                end,
            },
        }

        local function run_file()
            vim.cmd("wa")
            local file = vim.fn.expand("%:p")
            local ft   = vim.bo.filetype
            local runner = runners[ft]

            if not runner then
                vim.notify("No runner configured for filetype: " .. ft, vim.log.levels.WARN)
                return
            end

            local cmd
            if runner.compile then
                local compile_cmd, out = runner.compile(file)
                local run_cmd = runner.run(file, out)
                cmd = string.format(
                    "%s && echo '--- Running ---' && %s; echo '--- Exit code: '$?",
                    compile_cmd, run_cmd
                )
            else
                local run_cmd = runner.run(file, nil)
                cmd = string.format(
                    "echo '--- Running ---' && %s; echo '--- Exit code: '$?",
                    run_cmd
                )
            end

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
                close_on_exit = false,
                on_open = function(t)
                    vim.cmd("startinsert!")
                    vim.keymap.set("t", "<Esc>", function()
                        t:close()
                    end, { buffer = t.bufnr })
                end,
            })
            term:toggle()
        end

        vim.keymap.set("n", "<F9>", run_file, { desc = "Run file" })
        vim.keymap.set("n", "<leader>r", run_file, { desc = "Run file" })

        -- Terminal mode: Esc to go back to normal mode inside the generic terminal
        vim.keymap.set("t", "<C-x>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
    end,
}
