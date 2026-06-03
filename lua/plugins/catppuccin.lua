return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000, -- load before everything else
    config = function()
        require("catppuccin").setup({
            flavour = "mocha",
            transparent_background = false,
            integrations = {
                treesitter = true,
                native_lsp = {
                    enabled = true,
                    underlines = {
                        errors = { "undercurl" },
                        hints = { "undercurl" },
                        warnings = { "undercurl" },
                        information = { "undercurl" },
                    },
                },
                cmp = true,
                nvimtree = true,
                telescope = true,
                noice = true,
                mini = true,
            },
        })
        vim.cmd.colorscheme("catppuccin")
    end,
}
