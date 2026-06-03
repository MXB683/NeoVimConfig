return {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
        local autopairs = require("nvim-autopairs")
        local Rule = require("nvim-autopairs.rule")

        autopairs.setup({
            check_ts = true, -- use treesitter to check context
            ts_config = {
                c = { "string" },
                cpp = { "string" },
            },
        })

        -- Exploding brackets: pressing Enter inside {} [] () expands them
        local cond = require("nvim-autopairs.conds")
        autopairs.add_rules({
            Rule("{", "}")
                :with_pair(cond.none())
                :with_move(function(opts)
                    return opts.char == "}"
                end),
        })
    end,
}
