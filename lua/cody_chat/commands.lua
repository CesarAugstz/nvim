local M = {}
local chat = require('cody_chat')
local context = require('cody_chat.context')

function M.process_input()
  local input_lines = vim.api.nvim_buf_get_lines(chat.state.input_buf, 0, -1, false)
  local input = table.concat(input_lines, "\n")
  
  if input:match("^%s*$") then
    return
  end
  
  -- Check for special commands
  if input:match("^:add_file") then
    context.pick_context_file()
  elseif input:match("^:add_buffer") then
    context.pick_current_buffer_as_context()
  elseif input:match("^:list_files") then
    context.display_context_files()
  elseif input:match("^:clear_files") then
    context.clear_context_files()
  elseif input:match("^:clear") then
    vim.api.nvim_buf_set_lines(chat.state.history_buf, 0, -1, false, 
      {"# Cody Chat", "", "Chat history cleared.", ""})
  else
    -- Regular chat message
    chat.execute_cody_command(input)
  end
  
  -- Clear input field
  vim.api.nvim_buf_set_lines(chat.state.input_buf, 0, -1, false, {""})
end

return M
