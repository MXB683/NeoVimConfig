return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
            "nvim-neotest/nvim-nio",
            "williamboman/mason.nvim",
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            -- Virtual text showing variable values inline
            require("nvim-dap-virtual-text").setup({
                commented = true, -- show as comment
            })

            -- DAP UI setup
            dapui.setup({
                icons = { expanded = "", collapsed = "", current_frame = "" },
                layouts = {
                    {
                        elements = {
                            { id = "scopes",      size = 0.40 },
                            { id = "breakpoints", size = 0.20 },
                            { id = "stacks",      size = 0.20 },
                            { id = "watches",     size = 0.20 },
                        },
                        size = 45,
                        position = "left",
                    },
                    {
                        elements = {
                            { id = "repl",    size = 0.5 },
                            { id = "console", size = 0.5 },
                        },
                        size = 12,
                        position = "bottom",
                    },
                },
            })

            -- Auto open/close dapui with debug session
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end

            -- codelldb adapter
            -- Mason installs it here:
            local codelldb_path = vim.fn.stdpath("data") .. "/mason/bin/codelldb"

            dap.adapters.codelldb = {
                type = "server",
                port = "${port}",
                executable = {
                    command = codelldb_path,
                    args = { "--port", "${port}" },
                },
            }

            -- C and C++ configs
            dap.configurations.c = {
                {
                    name = "Launch file",
                    type = "codelldb",
                    request = "launch",
                    program = function()
                        -- asks you for the binary path each time
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                    end,
                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                    terminal = "integrated",
                },
            }
            dap.configurations.cpp = dap.configurations.c

            -- Breakpoint signs
            vim.fn.sign_define("DapBreakpoint",          { text = "●", texthl = "DapBreakpoint",         linehl = "", numhl = "" })
            vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
            vim.fn.sign_define("DapBreakpointRejected",  { text = "✗", texthl = "DapBreakpointRejected",  linehl = "", numhl = "" })
            vim.fn.sign_define("DapStopped",             { text = "▶", texthl = "DapStopped",             linehl = "DapStoppedLine", numhl = "" })

            -- Keybinds
            local map = function(keys, func, desc)
                vim.keymap.set("n", keys, func, { desc = desc })
            end

            map("<F5>",       dap.toggle_breakpoint,                       "Toggle breakpoint")
            map("<F7>",       dap.step_over,                               "Step over")
            map("<F11>",      dap.step_into,                               "Step into")
            map("<F12>",      dap.step_out,                                "Step out")
            map("<F8>",       dap.continue,                                "Continue / Start debugger")
            map("<leader>db", dap.toggle_breakpoint,                       "Toggle breakpoint")
            map("<leader>dB", function()
                dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
            end,                                                           "Conditional breakpoint")
            map("<leader>dc", dap.continue,                                "Continue")
            map("<leader>do", dap.step_over,                               "Step over")
            map("<leader>di", dap.step_into,                               "Step into")
            map("<leader>dO", dap.step_out,                                "Step out")
            map("<leader>dr", dap.repl.open,                               "Open REPL")
            map("<leader>du", dapui.toggle,                                "Toggle DAP UI")
            map("<leader>dx", dap.terminate,                               "Terminate")

            local function compile_and_debug()
                local file = vim.fn.expand("%:p")
                local out  = vim.fn.expand("%:p:r") .. "_debug"
                local ft   = vim.bo.filetype

                if ft ~= "c" and ft ~= "cpp" then
                    vim.notify("Not a C/C++ file", vim.log.levels.WARN)
                    return
                end

                local compiler = ft == "c" and "gcc" or "g++"
                local cmd = string.format("%s -g -O0 '%s' -o '%s'", compiler, file, out)

                vim.notify("Compiling with debug symbols...", vim.log.levels.INFO)

                local result = vim.fn.system(cmd)
                if vim.v.shell_error ~= 0 then
                    vim.notify("Compilation failed:\n" .. result, vim.log.levels.ERROR)
                    return
                end

                vim.notify("Compiled: " .. out, vim.log.levels.INFO)

                -- Override the program for this session so no prompt appears
                dap.configurations.c[1].program = out
                dap.configurations.cpp[1].program = out

                dap.continue()
            end

            map("<F10>", compile_and_debug, "Compile (debug) and launch DAP")
        end,
    },
}
