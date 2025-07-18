local opts = { noremap = true, silent = true }
local remapopts = { noremap = false, silent = true }
-- Shorten function name
local keymap = vim.keymap.set

keymap("n", "<ESC>", "<cmd>noh<CR>", opts)  -- stop highlight with esc

keymap("i", "kj", "<ESC>", opts)  -- exit with kj
keymap("i", "jk", "<ESC>", opts)
keymap("v", "mn", "<ESC>", opts)

keymap({"n","v"}, ",", "=", opts)  -- , fixes indentations
keymap("n", "e", "<C-w>", opts)  -- e for window

keymap({"n","v"}, "<Up>", "15<C-y>", opts)  -- long scroll
keymap({"n","v"}, "<Down>", "15<C-e>", opts)
keymap({"n","v"}, "=", "5<C-y>", opts)  -- short scroll
keymap({"n","v"}, "-", "5<C-e>", opts)

-- tagbar?
-- line 228: identify syntax highlighting group (inspect?)

keymap("n", "<space>", "za", opts)

keymap({"n","v"}, "H", "^", opts)  -- HJKL fast moving
keymap({"n","v"}, "J", "3j", opts)
keymap({"n","v"}, "K", "3k", opts)
keymap({"n","v"}, "L", "$", opts)

keymap({"n","v"}, "(", "<C-o>", opts)  -- next and previous position
keymap({"n","v"}, ")", "<C-i>", opts)
keymap({"n"}, "gd", "<C-]>", opts)

keymap("n", "d-", "O<esc>jddk", opts)  -- delete without erasing
keymap("n", "go", "%", opts)  -- go (to next parenthesis)

keymap("o", "l", "$", opts)  -- make dh, dl useful (all the way over) in operator pending mode
keymap("o", "h", "^", opts)

keymap("n", "U", "<C-r>", opts)  -- U to redo

keymap("n", "g-", "<C-o>", opts)  -- g- to go to last
keymap("n", "g=", "<C-i>", opts)  -- g- to go to previous

keymap({"n","v"}, "j", "gj", opts)  -- move displayed lines instead of real lines
keymap({"n","v"}, "k", "gk", opts)  -- move displayed lines instead of real lines

keymap("n", "?", vim.lsp.buf.hover, opts)  -- move displayed lines instead of real lines

keymap("v", "<C-c>", "\"+y", opts)  -- Ctrl+c to copy in visual mode
