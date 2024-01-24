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

    termguicolors = true,
    -- signcolumn = "yes:2",
    signcolumn = "yes:1",

    mouse = "a",

    expandtab = true,
    tabstop = 4,
    shiftwidth = 0,
}

for k, v in pairs(options) do
    vim.opt[k] = v
end


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
