local opts = { noremap = true, silent = true }
local remapopts = { noremap = false, silent = true }
local keymap = vim.keymap.set

-- indent blankline (indent indicator)
require('ibl').setup({
    indent = {
        char = "╎",
    },
    scope = {
        enabled = false,
    },
})

-- disable italics for neovim rose pine
require('rose-pine').setup({
    disable_italics = true,
    styles = {
      bold = true,
      italic = false,
      transparency = false
    },

    highlight_groups = {
       Comment = { italic = true }
    }
})
vim.cmd("colorscheme rose-pine-moon")  -- has to go after setup


-- hop.nvim
--
local hop = require('hop')
hop.setup({
    keys = "sdfjklghzcvbnmweruioqa "
})
-- normal, operator pending, visual mode: g<direction> to go
keymap({"n","o","v"}, "gh", "<cmd>HopWordCurrentLineBC<CR>", opts)
keymap({"n","o","v"}, "gj", "<cmd>HopVerticalAC<CR>", opts)
keymap({"n","o","v"}, "gk", "<cmd>HopVerticalBC<CR>", opts)
keymap({"n","o","v"}, "gl", "<cmd>HopWordCurrentLineAC<CR>", opts)
keymap({"n","o","v"}, "s", "<cmd>HopChar2<CR>", opts)

-- missing: line 180 autopairs and toggle

-- undotree
keymap("n", "*", "<cmd>UndotreeToggle<CR>", {})


-- gitsigns.nvim
require('gitsigns').setup {
    signs = {
        add          = { text = '│' },
        change       = { text = '│' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
    },
    signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
    watch_gitdir = {
        follow_files = true
    },
    attach_to_untracked = true,
    sign_priority = 6,
    update_debounce = 100,

    preview_config = {
        -- Options passed to nvim_open_win
        border = 'single',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1
    },
    -- yadm = {
    --     enable = false
    -- },
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', 'g]', function()
            if vim.wo.diff then return 'g]' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
        end, {expr=true})

        map('n', 'g[', function()
            if vim.wo.diff then return 'g[' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
        end, {expr=true})

        -- Actions
        map('n', 'g\\', gs.preview_hunk)
        map('n', '<leader>gs', gs.stage_hunk)
        map('v', '<leader>gs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
        map('n', '<leader>gS', gs.stage_buffer)
        map('n', '<leader>gu', gs.undo_stage_hunk)
        map('n', '<leader>gb', function() gs.blame_line{full=true} end)
        map('n', '<leader>gd', gs.diffthis)
        map('n', '<leader>gD', function() gs.diffthis('~') end)
        map('n', '<leader>g?', gs.toggle_deleted)

        -- Text object
        map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
    end
}


-- nvim-treesitter
require'nvim-treesitter.configs'.setup {
    sync_install = true,

    highlight = {
        enable = true,

        -- disable = {"python", "java", "vim"},
        disable = {"markdown_inline"},

        -- additional_vim_regex_highlighting = false,
    },
}

-- glow markdown preview
require('glow').setup()


-- Comment.nvim
require('Comment').setup({
    padding = true,
    toggler = {
        line = "#",
    },
    opleader = {
        line = "#",
    }
})

-- nvim-lastplace
require'nvim-lastplace'.setup {
    lastplace_ignore_buftype = {"quickfix", "nofile", "help"},
    lastplace_ignore_filetype = {"gitcommit", "gitrebase", "svn", "hgcommit"},
    lastplace_open_folds = true
}


-- mini.map
--require('mini.map').setup()
--MiniMap.open()



-- nvim-tree.lua
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

local function nvimtree_on_attach(bufnr)
    local api = require "nvim-tree.api"

    local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    -- default mappings
    -- api.config.mappings.default_on_attach(bufnr)

    -- custom mappings
    vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open'))
    vim.keymap.set('n', '<C-t>', api.tree.change_root_to_parent, opts('Up'))
    vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
end

require("nvim-tree").setup({
    sort = {
        sorter = "case_sensitive",
    },
    view = {
        width = 24,
    },
    renderer = {
        group_empty = true,
    },
    modified = {
        enable = true,
    },
    filters = {
        dotfiles = true,
    },
    on_attach = nvimtree_on_attach,

    disable_netrw = false,
    hijack_netrw = true,
})

local function open_nvim_tree()
  require("nvim-tree.api").tree.open()
  vim.cmd("wincmd p")
end
vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })


-- nvim-lualine
-- https://www.reddit.com/r/neovim/comments/1829ffv/how_to_force_lualine_to_show_filename_when_you/
local function path_option()
    return 1
end
require('lualine').setup({
    options = {
        theme = 'rose-pine',
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
    },
    sections = {
        lualine_c = {
            ...,
            {
                'filename',
                path = path_option(),
            },
            'lsp_progress',
        }
    }
})


-- hlslens

local kopts = {noremap = true, silent = true}
vim.api.nvim_set_keymap('n', 'n',
    [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
    kopts)
vim.api.nvim_set_keymap('n', 'N',
    [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
    kopts)
-- vim.api.nvim_set_keymap('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
-- vim.api.nvim_set_keymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)

vim.api.nvim_set_keymap('n', '<Leader>l', '<Cmd>noh<CR>', kopts)


-- nvim-scrollbar
require("scrollbar").setup({
    excluded_buftypes = {
        ...,
    },
    marks = {
        Search = {
            color = require('rose-pine.palette').rose
        },
    },
    excluded_filetypes = {  -- exclude windows and files that don't need scrollbars
        ...,
        "NvimTree",
        "",
    },
})
require("scrollbar.handlers.gitsigns").setup()
require("scrollbar.handlers.search").setup({
    override_lens = function() end,
})


-- nvim autopairs
require("nvim-autopairs").setup({
    ignored_next_char = "[%w%.]", -- will ignore alphanumeric and `.` symbol
    disable_filetype = {
        ...,
    },
})

local Rule = require('nvim-autopairs.rule')
local npairs = require('nvim-autopairs')
local cond = require('nvim-autopairs.conds')
npairs.add_rule(Rule(
    "{",
    "}"
))
npairs.add_rule(Rule(
    "(",
    ")",
    { "lisp" }
):with_pair(cond.not_filetypes({"lua"})))



-- flash
-- require("flash").setup({
--
-- })




-- nvim-web-devicons (copied directly)
require'nvim-web-devicons'.setup {
 -- your personnal icons can go here (to override)
 -- you can specify color or cterm_color instead of specifying both of them
 -- DevIcon will be appended to `name`
 override = {
  zsh = {
    icon = "",
    color = "#428850",
    cterm_color = "65",
    name = "Zsh"
  }
 };
 -- globally enable different highlight colors per icon (default to true)
 -- if set to false all icons will have the default icon's color
 color_icons = true;
 -- globally enable default icons (default to false)
 -- will get overriden by `get_icons` option
 default = true;
 -- globally enable "strict" selection of icons - icon will be looked up in
 -- different tables, first by filename, and if not found by extension; this
 -- prevents cases when file doesn't have any extension but still gets some icon
 -- because its name happened to match some extension (default to false)
 strict = true;
 -- same as `override` but specifically for overrides by filename
 -- takes effect when `strict` is true
 override_by_filename = {
  [".gitignore"] = {
    icon = "",
    color = "#f1502f",
    name = "Gitignore"
  }
 };
 -- same as `override` but specifically for overrides by extension
 -- takes effect when `strict` is true
 override_by_extension = {
  ["log"] = {
    icon = "",
    color = "#81e043",
    name = "Log"
  }
 };
}
