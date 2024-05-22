local line_ok, formatter = pcall(require, "formatter")

if not line_ok then
  return
end

local prettier_filetypes = {
  "javascript",
  "typescript",
  "vue",
  "Vue",
  "json",
  "html",
  "css",
  "scss",
}

local function is_prettier_filetype(filetype)
  for i = 1, #prettier_filetypes do
    if (prettier_filetypes[i] == filetype) then
      return true
    end
  end
  return false
end


formatter.setup({
  logging = true,
  log_level = vim.log.levels.DEBUG,
  filetype = {
    lua = {
      -- luafmt
      function()
        return {
          exe = "stylua",
          args = { "--indent-count", 2, "--stdin" },
          stdin = true
        }
      end
    },
    ["*"] = {
      -- default vim
      function()
        if is_prettier_filetype(vim.bo.filetype) then
          return {
            exe = "prettierd",
            args = { vim.api.nvim_buf_get_name(0) },
            stdin = true
          }
        end
        vim.lsp.buf.format()
        return nil
      end
    },
  }
})
