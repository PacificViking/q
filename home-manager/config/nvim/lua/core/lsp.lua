require'lspconfig'.nil_ls.setup{}
require'lspconfig'.rust_analyzer.setup{}
-- require'lspconfig'.pylsp.setup{
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
require'lspconfig'.pyright.setup{}
