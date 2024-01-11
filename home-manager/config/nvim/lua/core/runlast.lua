vim.api.nvim_create_autocmd({"FileType"}, {  -- FileType *
    pattern = {"*"},
    callback = function()


vim.cmd("hi MatchParen gui=underline,bold guibg=none guifg=" .. require('rose-pine.palette').pine)
vim.cmd("hi Search guibg=" .. require('rose-pine.palette').rose)
vim.cmd("hi IncSearch guibg=" .. require('rose-pine.palette').gold)


    end,
})
