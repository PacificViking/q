local options = {
    ignorecase = true,
    number = true,
    hid = false,
    wmnu = true,
    eb = false,
    updatetime = 300,
    showmode = false,
    undofile = true,
    undodir = vim.fn.expand("~/.vim/undodir"),  -- expand ~ to $HOME
    conceallevel = 0,
    -- fixendofline = false,

    termguicolors = true,
    -- signcolumn = "yes:2",
    signcolumn = "yes:1",

    mouse = "a",

    expandtab = true,
    -- expandtab = false,
    tabstop = 4,
    shiftwidth = 0,
}

for k, v in pairs(options) do
    vim.opt[k] = v
end

vim.cmd("set iskeyword-=_")
vim.cmd("set iskeyword-=-")
vim.cmd("set colorcolumn=100")

vim.g.copilot_filetypes = {["*"] = false}  --no suggestions

function ToggleMouse()
    if vim.o.mouse == 'a' then
        vim.opt["mouse"] = ''
        print("Mouse Disabled")
    else
        vim.opt["mouse"] = 'a'
        print("Mouse Enabled")
    end
end
vim.keymap.set("n", "<C-x>", ToggleMouse, { silent=false })
