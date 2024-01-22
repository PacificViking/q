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

-- flake.lock
vim.api.nvim_create_autocmd({"BufNewFile","BufRead"}, {
    pattern = {"flake.lock"},
    callback = function()
        vim.cmd("setf json")
    end,
})

-- add config filetype for conf
vim.filetype.add({ extension = { conf = "config" } })

-- files containing config have filetype config
vim.api.nvim_create_autocmd({"BufNewFile","BufRead"}, {
    pattern = {"*config"},
    callback = function()
        vim.cmd("setf config")
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

-- html folds
vim.api.nvim_create_autocmd("FileType", {
    pattern = {"html"},
    callback = function()
        vim.opt["foldmethod"] = "indent"
        vim.cmd("normal zR")
    end,
})
