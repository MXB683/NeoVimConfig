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

local function run_current_file(Terminal)
    local file = vim.fn.expand("%:p")
    local ft = vim.bo.filetype
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
            "echo '--- Compiling ---' && %s && echo '--- Running ---' && %s; echo '--- Exit code: '$?",
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
                return math.floor(vim.o.columns * 0.75)
            end,
            height = function()
                return math.floor(vim.o.lines * 0.75)
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

local function run(Terminal)
    local project_dir = vim.fn.getcwd()
    local runconfig_path = project_dir .. "/runconfig"
    if vim.fn.filereadable(runconfig_path) == 0 then
        if vim.fn.confirm("No runconfig found in project root. Run current file instead?", "&Yes\n&No", 1) == 1 then
            run_current_file(Terminal)
        end
    else
        local runconfig_string = vim.fn.readfile(runconfig_path)
        -- runconfig format:
        -- compile=<cmd>
        -- run=<cmd>
        -- compile_debug=<cmd>
        -- run_debug=<cmd>
        -- keep_terminal_open=<true|false>
        local runconfig = {}
        for i, line in ipairs(runconfig_string) do
            if not line:match("^%s*$") then
                local key, value = string.match(line, "([^=]+)=(.+)")
                if not key then
                    vim.notify("Line " .. i .. " of runconfig doesn't specify a key!", vim.log.levels.ERROR)
                    return
                end
                if not value then
                    value = ""
                end
                runconfig[key] = value
            end
        end
        if runconfig["compile"] then -- else is interpreted
            local cmd = string.format(
                "%s && echo '--- Running ---' && %s; echo '--- Exit code: '$?",
                runconfig["compile"], runconfig["run"]
            )
            local term = Terminal:new({
                cmd = cmd,
                direction = "float",
                float_opts = {
                    border = "curved",
                    width = function()
                        return math.floor(vim.o.columns * 0.75)
                    end,
                    height = function()
                        return math.floor(vim.o.lines * 0.75)
                    end,
                },
                close_on_exit = runconfig["keep_terminal_open"] ~= "true",
                on_open = function(t)
                    vim.cmd("startinsert!")
                    vim.keymap.set("t", "<Esc>", function()
                        t:close()
                    end, { buffer = t.bufnr })
                end,
            })
            term:toggle()
        end
        if not runconfig["run"] then
            vim.notify("No run command specified in runconfig!", vim.log.levels.ERROR)
        end

        local cmd = string.format(
            "echo '--- Running ---' && %s; echo '--- Exit code: '$?",
            runconfig["run"]
        )
        local term = Terminal:new({
            cmd = cmd,
            direction = "float",
            float_opts = {
                border = "curved",
                width = function()
                    return math.floor(vim.o.columns * 0.75)
                end,
                height = function()
                    return math.floor(vim.o.lines * 0.75)
                end,
            },
            close_on_exit = runconfig["keep_terminal_open"] ~= "true",
            on_open = function(t)
                vim.cmd("startinsert!")
                vim.keymap.set("t", "<Esc>", function()
                    t:close()
                end, { buffer = t.bufnr })
            end,
        })
        term:toggle()
    end
end

return {
    run = run,
}

