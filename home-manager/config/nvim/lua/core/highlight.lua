vim.cmd "hi MatchParen cterm=underline,bold ctermbg=none ctermfg=blue"  -- make matching parenthesis more readable

-- not migrated: ~line 145
vim.api.nvim_create_autocmd({"BufReadPost"}, {  -- set .conf files' filetypes to config
    pattern = {"*.conf"},
    callback = function()
        vim.opt["filetype"] = config
    end,
})


-- hlslens highlighting
vim.cmd("hi CurSearch guibg=" .. require('rose-pine.palette').rose)

vim.cmd([[
hi link HlSearchNear IncSearch
hi link HlSearchLens WildMenu
hi link HlSearchLensNear IncSearch
]])

