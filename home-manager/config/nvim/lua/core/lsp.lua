-- require("lsp_signature").setup({
--     bind = true,
-- })

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local lspsetup = {
    -- on_attach = function(client, bufnr)
    --     require("lsp_signature").on_attach(signature_setup, bufnr)
    -- end,
    capabilities = capabilities,
}

require'lspconfig'.nil_ls.setup(lspsetup)  -- theres a bug that come from using capabilites? not sure
require'lspconfig'.rust_analyzer.setup(lspsetup)
-- require'lspconfig'.pylsp.setup{
--   capabilities = capabilities,
--   settings = {
--     pylsp = {
--       plugins = {
--         pycodestyle = {
--           -- ignore = {'W123'},
--           maxLineLength = 100
--         }
--       }
--     }
--   }
-- }
-- require'lspconfig'.pylsp.setup{}
require'lspconfig'.pyright.setup(lspsetup)
require'lspconfig'.luau_lsp.setup(lspsetup)


vim.api.nvim_set_hl(0, "CmpNormal", {
    bg = require('rose-pine.palette').overlay,
})
vim.api.nvim_set_hl(0, "CmpCursorLine", {
    bg = require('rose-pine.palette').highlight_high,
})

local cmp = require('cmp')
cmp.setup({
    native_menu = true;
    -- snippet = {
    --   expand = function(args)
    --     vim.fn["UltiSnips#Anon"](args.body)
    --   end,
    -- },
    window = {
        completion = {
            winhighlight = "Normal:CmpNormal,CursorLine:CmpCursorLine"
        }
    },
    mapping = cmp.mapping.preset.insert({
      -- ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      -- ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-a>'] = cmp.mapping.complete(),
      ['<C-c>'] = cmp.mapping.abort(),
      ['<C-Tab>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'path' },
        -- { name = 'zsh' },
        -- { name = 'ultisnips' },
    }, {
        -- { name = 'nvim_lsp_signature_help' },
        -- { name = 'nvim_lsp_document_symbol' },
    }),
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
    }, {
      { name = 'buffer' },
    })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      -- { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
mapping = cmp.mapping.preset.cmdline(),
sources = cmp.config.sources({
      -- { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
})

-- Set up lspconfig.
-- local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
-- capabilities = capabilities
-- }
--


-- vim.keymap.set({ 'n', 'i' }, '<C-k>', function()
--     require('lsp_signature').toggle_float_win()
--     end, 
--     { silent = true, noremap = true, desc = 'toggle signature' }
-- )

vim.keymap.set({ 'n', 'i' }, '<C-/>', function()
    vim.lsp.buf.signature_help()
    -- vim.lsp.buf.completion()
    end,
    { silent = true, noremap = true, desc = 'toggle signature' }
)

