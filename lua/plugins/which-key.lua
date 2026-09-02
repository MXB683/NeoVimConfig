return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
        local wk = require("which-key")

        wk.setup({
            preset = "modern",
            delay = 0,
            win = {
                border = "rounded",
            },
        })

        -- Group labels so the popup is organized instead of a flat list
        wk.add({
            { "<leader>d",  group = "Debug" },
            { "<leader>c",  group = "Copilot" },
            { "<leader>e",  desc = "Search everywhere" },
            { "<F8>",       desc = "DAP: Continue / Start" },
            { "<F9>",       desc = "DAP: Toggle breakpoint" },
            { "<F10>",      desc = "DAP: Compile & debug" },
            { "<F11>",      desc = "DAP: Step into" },
            { "<F12>",      desc = "DAP: Step out" },
        })
    end,
}
