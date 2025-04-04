local M = {}
local chat = require('cody_chat')
local context = require('cody_chat.context')

function M.create_split_chat_ui()
  -- Create the main chat history window (takes most of the space)
  local history = chat.create_floating_window()
  chat.state.history_buf = history.buf
  chat.state.floating.win = history.win
  
  -- Set options for history buffer
  vim.api.nvim_buf_set_option(chat.state.history_buf, "buftype", "nofile")
  vim.api.nvim_buf_set_option(chat.state.history_buf, "swapfile", false)
  vim.api.nvim_buf_set_option(chat.state.history_buf, "filetype", "markdown")
  vim.api.nvim_buf_set_name(chat.state.history_buf, "CodyChat")
  
  -- Create input area at the bottom
  local win_height = vim.api.nvim_win_get_height(chat.state.floating.win)
  local win_width = vim.api.nvim_win_get_width(chat.state.floating.win)
  
  -- Create input buffer
  chat.state.input_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(chat.state.input_buf, "buftype", "nofile")
  vim.api.nvim_buf_set_option(chat.state.input_buf, "swapfile", false)
  
  -- Create input window (just a few lines at the bottom)
  local input_height = 3
  local history_height = win_height - input_height - 2
  
  -- Resize history window
  vim.api.nvim_win_set_height(chat.state.floating.win, history_height)
  
  -- Create input window below history
  local input_win_config = {
    relative = "win",
    win = chat.state.floating.win,
    width = win_width - 4,
    height = input_height,
    col = 2,
    row = history_height,
    style = "minimal",
    border = "rounded",
    title = "Ask Cody",
    title_pos = "center",
  }
  
  chat.state.input_win = vim.api.nvim_open_win(chat.state.input_buf, true, input_win_config)
  
  -- Set window options
  vim.api.nvim_win_set_option(chat.state.input_win, "winhighlight", "Normal:Normal,FloatBorder:FloatBorder")
  
  -- Add initial instructions to history buffer
  local instructions = {
    "# Cody Chat",
    "",
    "Type your question in the input area below and press <C-Enter> to send.",
    "",
    "Commands:",
    "- `:add_file` - Add a file using FZF picker",
    "- `:add_buffer` - Add current buffer as context",
    "- `:list_files` - List all context files",
    "- `:clear_files` - Clear all context files",
    "- `:clear` - Clear chat history",
    "",
    "Shortcuts:",
    "- Type `@` to quickly add a file to context",
    "- Type `#` to add a directory (max 20 files)",
    ""
  }
  
  vim.api.nvim_buf_set_lines(chat.state.history_buf, 0, -1, false, instructions)
  
  -- Set input window to insert mode
  vim.api.nvim_set_current_win(chat.state.input_win)
  vim.cmd("startinsert")
  
  -- Set up keymaps
  vim.api.nvim_buf_set_keymap(chat.state.input_buf, 'i', '<C-CR>', 
    [[<Esc><Cmd>lua require('cody_chat.commands').process_input()<CR>]], 
    {noremap = true, silent = true})
    
  vim.api.nvim_buf_set_keymap(chat.state.input_buf, 'n', '<CR>', 
    [[<Cmd>lua require('cody_chat.commands').process_input()<CR>]], 
    {noremap = true, silent = true})
    
  -- Add @ keymap to trigger file picker
  vim.api.nvim_buf_set_keymap(chat.state.input_buf, 'i', '@', 
    [[<Cmd>lua require('cody_chat.context').trigger_file_picker_at_cursor()<CR>]], 
    {noremap = true, silent = true})
    
  -- Add # keymap to trigger directory picker
  vim.api.nvim_buf_set_keymap(chat.state.input_buf, 'i', '#', 
    [[<Cmd>lua require('cody_chat.context').trigger_directory_picker_at_cursor()<CR>]], 
    {noremap = true, silent = true})
end

function M.toggle_cody_chat()
  local chat_visible = vim.api.nvim_win_is_valid(chat.state.floating.win)
  
  if not chat_visible then
    -- Check if history buffer still exists and is valid
    local history_buf_valid = chat.state.history_buf > 0 and vim.api.nvim_buf_is_valid(chat.state.history_buf)
    local input_buf_valid = chat.state.input_buf > 0 and vim.api.nvim_buf_is_valid(chat.state.input_buf)
    
    if history_buf_valid and input_buf_valid then
      -- Reuse existing buffers
      local history = chat.create_floating_window({ buf = chat.state.history_buf })
      chat.state.floating.win = history.win
      
      -- Recreate input window
      local win_height = vim.api.nvim_win_get_height(chat.state.floating.win)
      local win_width = vim.api.nvim_win_get_width(chat.state.floating.win)
      
      local input_height = 3
      local history_height = win_height - input_height - 2
      
      -- Resize history window
      vim.api.nvim_win_set_height(chat.state.floating.win, history_height)
      
      -- Create input window below history
      local input_win_config = {
        relative = "win",
        win = chat.state.floating.win,
        width = win_width - 4,
        height = input_height,
        col = 2,
        row = history_height,
        style = "minimal",
        border = "rounded",
        title = "Ask Cody",
        title_pos = "center",
      }
      
      chat.state.input_win = vim.api.nvim_open_win(chat.state.input_buf, true, input_win_config)
      vim.api.nvim_win_set_option(chat.state.input_win, "winhighlight", "Normal:Normal,FloatBorder:FloatBorder")
      
      -- Set input window to insert mode
      vim.api.nvim_set_current_win(chat.state.input_win)
      vim.cmd("startinsert")
    else
      -- Create new chat interface if buffers aren't valid
      M.create_split_chat_ui()
    end
  else
    vim.api.nvim_win_hide(chat.state.floating.win)
    if vim.api.nvim_win_is_valid(chat.state.input_win) then
      vim.api.nvim_win_hide(chat.state.input_win)
    end
  end
end

return M
