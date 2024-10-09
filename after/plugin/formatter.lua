local line_ok, formatter = pcall(require, "formatter")

if not line_ok then return end

local prettier_filetypes = {
  "javascript", "typescript", "vue", "Vue", "json", "html", "css", "scss", "typescriptreact", "javascriptreact"
}

local eslint_filetypes = {
  "javascript", "typescript", "typescriptreact", "javascriptreact"
}

local function is_eslint_filetype(filetype)
  for i = 1, #eslint_filetypes do
    if (eslint_filetypes[i] == filetype) then return true end
  end
  return false
end

local function is_prettier_filetype(filetype)
  for i = 1, #prettier_filetypes do
    if (prettier_filetypes[i] == filetype) then return true end
  end
  return false
end


formatter.setup({
  logging = true,
  log_level = vim.log.levels.DEBUG,
  ignore_exitcode = false,
  filetype = {
    lua = {
      -- luafmt
      function()
        return { exe = "lua-format", args = { "--indent-width", 2 }, stdin = true }
      end
    },
    ["*"] = {
      -- default vim
      function()
        --if is_eslint_filetype(vim.bo.filetype) then
        --  return {
        --    exe = "eslint",
        --    args = { "--fix-dry-run --stdin", vim.api.nvim_buf_get_name(0) },
        --    stdin = true
        --  }
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
    }
  }
})
