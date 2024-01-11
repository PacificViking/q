-- filetype specific
--
-- initial vimscript pg 82: concealing json

-- all files named "Jenkinsfile" are highlighted as groovy
vim.api.nvim_create_autocmd({"BufNewFile","BufRead"}, {
    pattern = {"Jenkinsfile"},
    callback = function()
        vim.cmd("setf groovy")
    end,
})

-- shift width 2 for nix
vim.api.nvim_create_autocmd("FileType", {
    pattern = {"nix"},
    callback = function()
        vim.opt["shiftwidth"] = 2
    end,
})

-- this may fall apart after async stuff?
-- don't add buffer when commenting python
vim.api.nvim_create_autocmd("FileType", {
    pattern = {"python"},
    callback = function()
        require('Comment').setup({
            padding = false,
        })
    end,
})
