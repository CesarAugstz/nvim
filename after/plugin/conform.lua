
local jsFormat = { "prettierd", "prettier", stop_after_first = true }

require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "isort", "black" },
    rust = { "rustfmt", lsp_format = "fallback" },
    javascript = jsFormat,
    typescript = jsFormat,
    typescriptreact = jsFormat,
    javascriptreact = jsFormat,
    vue = jsFormat,
  },
})