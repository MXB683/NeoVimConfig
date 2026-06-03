return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter").setup({
            ensure_installed = {
                "c", "cpp", "lua", "vim", "vimdoc",
                "bash", "markdown", "markdown_inline", "json",
            },
            auto_install = true,
        })
    end,
}
