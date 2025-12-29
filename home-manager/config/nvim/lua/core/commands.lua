vim.api.nvim_create_user_command('W', ':SudaWrite', {})
vim.api.nvim_create_user_command('Ivim', ':tabnew ~/dotconf/nvim/lua/core', {})
vim.api.nvim_create_user_command('BrowseHTML', 'TOhtml | w! /tmp/nvim.html | close | silent !xdg-open /tmp/nvim.html', {})
-- command! TOhtmlBrowser TOhtml | w /tmp/nvim.html | silent !xdg-open /tmp/nvim.html

