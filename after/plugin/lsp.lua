if not module_exists("lsp-zero") then return end



local lsp = require('lsp-zero')

lsp.preset('recommended')

-- Fix Undefined global 'vim'
lsp.nvim_workspace()
-- fib function


lsp.ensure_installed({ 'vtsls' })

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
  ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
  ['<C-y>'] = cmp.mapping.confirm({ select = true }),
  ["<C-Space>"] = cmp.mapping.complete(),
  ['Tab'] = nil,
  ['S-Tab'] = nil
})
local cmp_sources = {
  { name = 'cody' },
  { name = 'nvim_lsp' },
  { name = 'buffer' },
  { name = 'luasnip' },
}

local cmp_format = require('lsp-zero').cmp_format({ details = true })

cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

lsp.setup_nvim_cmp({
  mapping = cmp_mappings,
  sources = cmp_sources,
  formatting = cmp_format,
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end
  },

})

--cmp.setup({
--  sources = cmp_sources,
--  formatting = cmp_format,
--  mapping = cmp_mappings
--})

lsp.set_preferences({
  suggest_lsp_servers = false,
  sign_icons = { error = 'E', warn = 'W', hint = 'H', info = 'I' }
})

lsp.on_attach(function(client, bufnr)
  local opts = { buffer = bufnr, remap = false }

  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vws",
    function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end,
    opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end,
    opts)
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end,
    opts)
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap
      .set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

lsp.setup()

vim.diagnostic.config({ virtual_text = true })

lsp.setup()

local lspconfig = require('lspconfig')

-- Use project-local typescript installation if available, fallback to global install
-- assumes typescript installed globally w/ nvm
local function get_typescript_server_path(root_dir)
  local global_ts = vim.fn.expand(
    "$NVM_DIR/versions/node/$DEFAULT_NODE_VERSION/lib/node_modules/typescript/lib")
  local project_ts = ""
  local function check_dir(path)
    project_ts = lspconfig.util.path.join(path, "node_modules", "typescript",
      "lib")
    if lspconfig.util.path.exists(project_ts) then return path end
  end
  if lspconfig.util.search_ancestors(root_dir, check_dir) then
    return project_ts
  else
    return global_ts
  end
end

-- ts/js/vue
lspconfig.volar.setup({
  -- enable "take over mode" for typescript files as well: https://github.com/johnsoncodehk/volar/discussions/471
  filetypes = { "typescript", "javascript", "vue" },
  on_new_config = function(new_config, new_root_dir)
    new_config.init_options.typescript.tsdk =
        get_typescript_server_path(new_root_dir)
  end
})
