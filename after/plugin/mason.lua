require('mason').setup()

--require('mason-lspconfig').setup({ensure_installed = {'vtsls'}})

require'lspconfig'.ocamllsp.setup{}
