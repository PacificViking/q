vim.api.nvim_create_autocmd({"FileType"}, {  -- FileType *
    pattern = {"*"},
    callback = function()

rosepine = require('rose-pine.palette')

if vim.bo.filetype ~= "NvimTree" then
if vim.bo.filetype ~= "blink-cmp-signature" then
if vim.bo.filetype ~= "blink-cmp-menu" then
if vim.bo.filetype ~= "oil" then
if vim.bo.filetype ~= "text" then
    vim.treesitter.start()
end
end
end
end
end

vim.cmd("hi MatchParen gui=underline,bold guibg=none guifg=" .. rosepine.pine)
vim.api.nvim_set_hl(0, 'Search', { bg=rosepine.rose, fg=rosepine.pine })
vim.api.nvim_set_hl(0, 'IncSearch', { bg=rosepine.gold, fg=rosepine.pine })
-- vim.cmd("hi Search guibg=" .. require('rose-pine.palette').rose)
-- vim.cmd("hi IncSearch guibg=" .. require('rose-pine.palette').gold)


vim.g["mkdp_preview_options"] = {
    disable_sync_scroll = 1,
}

    end,
})
