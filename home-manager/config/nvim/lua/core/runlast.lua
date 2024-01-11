vim.api.nvim_create_autocmd({"FileType"}, {  -- FileType *
    pattern = {"*"},
    callback = function()

rosepine = require('rose-pine.palette')

vim.cmd("hi MatchParen gui=underline,bold guibg=none guifg=" .. rosepine.pine)
vim.api.nvim_set_hl(0, 'Search', { bg=rosepine.rose, fg=rosepine.pine })
vim.api.nvim_set_hl(0, 'IncSearch', { bg=rosepine.gold, fg=rosepine.pine })
-- vim.cmd("hi Search guibg=" .. require('rose-pine.palette').rose)
-- vim.cmd("hi IncSearch guibg=" .. require('rose-pine.palette').gold)


    end,
})
