-- vim.cmd("filetype indent off")
vim.cmd("hi MatchParen cterm=underline,bold ctermbg=none ctermfg=blue")  -- make matching parenthesis more readable

-- hlslens highlighting
vim.cmd("hi CurSearch guibg=" .. require('rose-pine.palette').rose)

vim.cmd([[
hi link HlSearchNear IncSearch
hi link HlSearchLens WildMenu
hi link HlSearchLensNear IncSearch
]])

