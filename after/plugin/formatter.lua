local line_ok, formatter = pcall(require, "formatter")

if not line_ok then
  return
end

formatter.setup({
  logging = false,
  filetype = {
    javascript = {
      -- prettierd
      function()
        return {
          exe = "prettierd",
          args = { vim.api.nvim_buf_get_name(0) },
          stdin = true
        }
      end
    },
    lua = {
      -- luafmt
      function()
        return {
          exe = "luafmt",
          args = { "--indent-count", 2, "--stdin" },
          stdin = true
        }
      end
    },
    typescript = {
      -- prettierd
      function()
        return {
          exe = "prettierd",
          args = { vim.api.nvim_buf_get_name(0) },
          stdin = true
        }
      end
    },
    vue = {
      -- prettierd
      function()
        return {
          exe = "prettierd",
          args = { vim.api.nvim_buf_get_name(0) },
          stdin = true
        }
      end
    },
    Vue = {
      -- prettierd
      function()
        return {
          exe = "prettierd",
          args = { vim.api.nvim_buf_get_name(0) },
          stdin = true
        }
      end
    },
  }
})
