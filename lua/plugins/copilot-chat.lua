return {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
        "zbirenbaum/copilot.lua",
        "nvim-lua/plenary.nvim",
    },
    config = function()
        require("CopilotChat").setup({
            window = {
                layout = "vertical",
                width  = 35,
            },
            headers = {
                user = ' You',
                assistant = '  Copilot',
                tool = ' Tool',
            },
            separator = "━━",
            auto_fold = true,
            show_help = false,
        })

        vim.api.nvim_create_autocmd('BufEnter', {
            pattern = 'copilot-chat',
            callback = function()
                vim.opt_local.relativenumber = false
                vim.opt_local.number = false
                vim.opt_local.conceallevel = 0
            end,
        })

        local map = vim.keymap.set

        map({ "n", "v" }, "<leader>cc", "<cmd>CopilotChatToggle<cr>",  { desc = "Toggle chat" })
        map({ "n", "v" }, "<leader>ce", "<cmd>CopilotChatExplain<cr>", { desc = "Explain" })
        map({ "n", "v" }, "<leader>cf", "<cmd>CopilotChatFix<cr>",     { desc = "Fix" })
        map({ "n", "v" }, "<leader>cr", "<cmd>CopilotChatReview<cr>",  { desc = "Review" })
        map({ "n", "v" }, "<leader>cd", "<cmd>CopilotChatDocs<cr>",    { desc = "Generate docs" })
    end,
}
