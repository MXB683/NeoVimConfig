local debuggers = {
    c = {
        command = "gcc",
        args = { "-g", "-O0" },
        output_flag = "-o",
        output_suffix = "_debug",
    },
    cpp = {
        command = "g++",
        args = { "-g", "-O0" },
        output_flag = "-o",
        output_suffix = "_debug",
    },
    python = {
        compile = false,
    },
}

local function shellescape(value)
    return vim.fn.shellescape(value)
end

local function read_runconfig()
    local path = vim.fn.getcwd() .. "/runconfig"
    if vim.fn.filereadable(path) == 0 then
        return nil
    end

    local runconfig = {}
    for i, line in ipairs(vim.fn.readfile(path)) do
        if not line:match("^%s*$") then
            local key, value = line:match("^%s*([^=]+)%s*=(.*)$")
            if not key then
                vim.notify("Line " .. i .. " of runconfig doesn't specify a key!", vim.log.levels.ERROR)
                return false
            end
            runconfig[key] = value
        end
    end

    return runconfig
end

local function compile(file, debugger)
    local output = vim.fn.expand("%:p:r") .. debugger.output_suffix
    local args = vim.tbl_map(shellescape, debugger.args)

    table.insert(args, shellescape(file))
    table.insert(args, debugger.output_flag)
    table.insert(args, shellescape(output))

    return table.concat({ debugger.command, table.concat(args, " ") }), output
end

local function compile_from_runconfig(runconfig)
    if not runconfig.compile_debug or runconfig.compile_debug == "" then
        return true
    end

    vim.notify("Compiling with debug symbols...", vim.log.levels.INFO)
    local result = vim.fn.system(runconfig.compile_debug)
    if vim.v.shell_error ~= 0 then
        vim.notify("Compilation failed:\n" .. result, vim.log.levels.ERROR)
        return false
    end

    return true
end

local function compile_and_debug(dap)
    local file = vim.fn.expand("%:p")
    local ft = vim.bo.filetype
    local runconfig = read_runconfig()

    if runconfig == false then
        return
    end

    if not runconfig
        and vim.fn.confirm("No runconfig found in project root. Run current file instead?", "&Yes\n&No", 1) ~= 1
    then
        return
    end

    local program
    local debug_filetype = ft
    if runconfig then
        debug_filetype = vim.trim(runconfig.dap_config or "")
        if debug_filetype == "" then
            vim.notify("No dap_config specified in runconfig!", vim.log.levels.ERROR)
            return
        end
        if not runconfig.run_debug or runconfig.run_debug == "" then
            vim.notify("No run_debug command specified in runconfig!", vim.log.levels.ERROR)
            return
        end
        if not compile_from_runconfig(runconfig) then
            return
        end
        program = runconfig.run_debug
    else
        local debugger = debuggers[ft]
        if not debugger then
            vim.notify("No debugger configured for filetype: " .. ft, vim.log.levels.WARN)
            return
        end

        if debugger.compile == false then
            program = file
        else
            local cmd
            cmd, program = compile(file, debugger)

            vim.notify("Compiling with debug symbols...", vim.log.levels.INFO)

            local result = vim.fn.system(cmd)
            if vim.v.shell_error ~= 0 then
                vim.notify("Compilation failed:\n" .. result, vim.log.levels.ERROR)
                return
            end

            vim.notify("Compiled: " .. program, vim.log.levels.INFO)
        end
    end

    local configuration = dap.configurations[debug_filetype] and dap.configurations[debug_filetype][1]
    if not configuration then
        vim.notify("No DAP configuration for filetype: " .. debug_filetype, vim.log.levels.ERROR)
        return
    end

    configuration.program = program
    dap.run(configuration)
end

return {
    compile_and_debug = compile_and_debug,
}
