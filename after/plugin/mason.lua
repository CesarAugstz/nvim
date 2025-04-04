if not module_exists("mason") then return end

require('mason').setup()

--require('mason-lspconfig').setup({ensure_installed = {'vtsls'}})

require'lspconfig'.ocamllsp.setup{}
