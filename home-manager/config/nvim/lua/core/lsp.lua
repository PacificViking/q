local lspsetup = {
}

require'lspconfig'.nil_ls.setup(lspsetup)  -- theres a bug that come from using capabilites? not sure
require'lspconfig'.rust_analyzer.setup(lspsetup)
vim.g.rustfmt_autosave = 1

require'lspconfig'.ruff.setup(lspsetup)
require'lspconfig'.pyright.setup(lspsetup)
require'lspconfig'.luau_lsp.setup(lspsetup)
require'lspconfig'.marksman.setup(lspsetup)


vim.api.nvim_set_hl(0, "CmpNormal", {
    bg = require('rose-pine.palette').overlay,
})
vim.api.nvim_set_hl(0, "CmpCursorLine", {
    bg = require('rose-pine.palette').highlight_high,
})

vim.keymap.set({ 'n', 'i' }, '<C-/>', function()
    vim.lsp.buf.signature_help()
    -- vim.lsp.buf.completion()
    end,
    { silent = true, noremap = true, desc = 'toggle signature' }
)


-- this is also the cmp (autocomplete) part
require('blink.cmp').setup {
  sources = {
    default = function(ctx)
      local success, node = pcall(vim.treesitter.get_node)
      if success and node and vim.tbl_contains({ 'comment', 'line_comment', 'block_comment' }, node:type()) then
        return { 'buffer' }
      else
        return { 'lsp', 'path', 'snippets', 'buffer' }
      end
    end
  },

  keymap = {
    preset = 'default',
    ['<C-tab>'] = { function(cmp) cmp.accept() end },
    ['<C-a>'] = { function(cmp) cmp.show({ providers = { 'snippets' } }) end },
    ['<C-c>'] = { function(cmp) cmp.hide() end },
    ['<Up>'] = { 'select_prev', 'fallback' },
    ['<Down>'] = { 'select_next', 'fallback' },
    ['<C-/>'] = { 'show_documentation', 'hide_documentation' },
  },

  completion = {
    list = {
      -- selection = "manual"
    },
    menu = {
      draw = {
        treesitter = { 'lsp' }
      }
    }
  },

  signature = { enabled = true }
}
