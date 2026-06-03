return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
        },
    },
    config = function()
        local telescope = require("telescope")
        local builtin   = require("telescope.builtin")

        telescope.setup({
            defaults = {
                border = true,
                layout_strategy = "horizontal",
                layout_config = {
                    horizontal = {
                        preview_width = 0.55,
                        results_width = 0.45,
                    },
                    width = 0.87,
                    height = 0.80,
                },
                file_ignore_patterns = { "node_modules", ".git/", "%.o", "%.a", "%.out", "%_debug" },
                prompt_prefix   = "   ",
                selection_caret = "  ",
                path_display    = { "truncate" },
            },
        })

        telescope.load_extension("fzf")

        vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Find files" })
        vim.keymap.set("n", "<C-S-p>", builtin.commands, { desc = "Command palette" })
        vim.keymap.set("n", "<leader>e", builtin.live_grep, { desc = "Search everywhere" })
        -- leader + space: find open buffers
        vim.keymap.set("n", "<leader><space>", builtin.buffers, { desc = "Find buffers" })
        -- leader + /: fuzzy search in current file
        vim.keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find, { desc = "Search in file" })
    end,
}
