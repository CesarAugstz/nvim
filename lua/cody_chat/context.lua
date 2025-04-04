local M = {}
local chat = require('cody_chat')

function M.add_context_file(file)
  -- Avoid adding duplicate files
  for _, existing_file in ipairs(chat.state.context_files) do
    if existing_file == file then
      return false
    end
  end
  
  table.insert(chat.state.context_files, file)
  return true
end

function M.remove_context_file(file)
  for i, existing_file in ipairs(chat.state.context_files) do
    if existing_file == file then
      table.remove(chat.state.context_files, i)
      return true
    end
  end
  return false
end

function M.display_context_files()
  local msg = "**Context Files:**\n"
  if #chat.state.context_files == 0 then
    msg = msg .. "  _No files added_"
  else
    for i, file in ipairs(chat.state.context_files) do
      msg = msg .. "  " .. i .. ". " .. file .. "\n"
    end
  end
  
  local current_lines = vim.api.nvim_buf_line_count(chat.state.history_buf)
  chat.append_to_buffer(chat.state.history_buf, current_lines, msg)
  chat.append_to_buffer(chat.state.history_buf, current_lines + #chat.state.context_files + 2, "")
end

function M.pick_context_file()
  -- Check if fzf.vim is available
  if vim.fn.exists('*fzf#run') == 0 then
    chat.append_to_buffer(chat.state.history_buf, vim.api.nvim_buf_line_count(chat.state.history_buf), 
      "**System:** FZF not found. Please install fzf.vim")
    return
  end
  
  -- Hide the chat temporarily
  local chat_visible = vim.api.nvim_win_is_valid(chat.state.floating.win)
  if chat_visible then
    vim.api.nvim_win_hide(chat.state.floating.win)
    if vim.api.nvim_win_is_valid(chat.state.input_win) then
      vim.api.nvim_win_hide(chat.state.input_win)
    end
  end
  
  -- Use FZF to pick a file
  vim.fn['fzf#run']({
    source = 'find . -type f -not -path "*/node_modules/*" -not -path "*/\\.*" | sort',
    sink = function(file)
      if chat_visible then
        require('cody_chat.ui').toggle_cody_chat() -- Reopen the chat
      end
      
      if M.add_context_file(file) then
        chat.append_to_buffer(chat.state.history_buf, vim.api.nvim_buf_line_count(chat.state.history_buf), 
          "**System:** Added file context: " .. file)
        chat.append_to_buffer(chat.state.history_buf, vim.api.nvim_buf_line_count(chat.state.history_buf), "")
      else
        chat.append_to_buffer(chat.state.history_buf, vim.api.nvim_buf_line_count(chat.state.history_buf), 
          "**System:** File already in context: " .. file)
        chat.append_to_buffer(chat.state.history_buf, vim.api.nvim_buf_line_count(chat.state.history_buf), "")
      end
    end,
    down = '40%'
  })
end

function M.pick_current_buffer_as_context()
  local current_file = vim.fn.expand('%:p')
  if current_file and current_file ~= "" then
    if M.add_context_file(current_file) then
      chat.append_to_buffer(chat.state.history_buf, vim.api.nvim_buf_line_count(chat.state.history_buf), 
        "**System:** Added current buffer as context: " .. current_file)
      chat.append_to_buffer(chat.state.history_buf, vim.api.nvim_buf_line_count(chat.state.history_buf), "")
    else
      chat.append_to_buffer(chat.state.history_buf, vim.api.nvim_buf_line_count(chat.state.history_buf), 
        "**System:** Current buffer already in context")
      chat.append_to_buffer(chat.state.history_buf, vim.api.nvim_buf_line_count(chat.state.history_buf), "")
    end
  else
    chat.append_to_buffer(chat.state.history_buf, vim.api.nvim_buf_line_count(chat.state.history_buf), 
      "**System:** No file is currently open")
    chat.append_to_buffer(chat.state.history_buf, vim.api.nvim_buf_line_count(chat.state.history_buf), "")
  end
end

function M.clear_context_files()
  chat.state.context_files = {}
  chat.append_to_buffer(chat.state.history_buf, vim.api.nvim_buf_line_count(chat.state.history_buf), 
    "**System:** Cleared all context files")
  chat.append_to_buffer(chat.state.history_buf, vim.api.nvim_buf_line_count(chat.state.history_buf), "")
end

function M.trigger_file_picker_at_cursor()
  -- Delete the '@' character that was just typed
  local cursor = vim.api.nvim_win_get_cursor(chat.state.input_win)
  local line = vim.api.nvim_buf_get_lines(chat.state.input_buf, cursor[1]-1, cursor[1], false)[1]
  
  local line_before = string.sub(line, 1, cursor[2])
  local line_after = string.sub(line, cursor[2] + 1)
  
  -- Remove the '@' character
  if string.sub(line_before, -1) == '@' then
    line_before = string.sub(line_before, 1, -2)
  end
  
  -- Save cursor position for later
  local saved_cursor = {cursor[1], #line_before}
  
  -- Check if fzf.vim is available
  if vim.fn.exists('*fzf#run') == 0 then
    chat.append_to_buffer(chat.state.history_buf, vim.api.nvim_buf_line_count(chat.state.history_buf), 
      "**System:** FZF not found. Please install fzf.vim")
    return
  end
  
  -- Store window and buffer states to restore them later
  local original_wins = {
    floating_win = chat.state.floating.win,
    input_win = chat.state.input_win,
    input_buf = chat.state.input_buf,
    history_buf = chat.state.history_buf
  }
  
  -- Use FZF to pick a file
  vim.fn['fzf#run']({
    source = 'find . -type f -not -path "*/node_modules/*" -not -path "*/\\.*" | sort',
    sink = function(file)
      -- Ensure chat windows are still valid
      local windows_valid = vim.api.nvim_win_is_valid(original_wins.floating_win) and 
                            vim.api.nvim_win_is_valid(original_wins.input_win)
      
      if not windows_valid then
        -- If windows are not valid, reopen the chat
        require('cody_chat.ui').create_split_chat_ui()
      else
        -- Make sure floating window is visible (in case it was hidden)
        vim.api.nvim_win_set_option(original_wins.floating_win, "hidden", false)
        vim.api.nvim_win_set_option(original_wins.input_win, "hidden", false)
      end
      
      -- Add file to context
      local added = M.add_context_file(file)
      
      -- Get file name without path for insertion
      local filename = file:match("([^/]+)$")
      
      -- Update the line with the filename instead of '@'
      local new_line = line_before .. filename .. line_after
      vim.api.nvim_buf_set_lines(chat.state.input_buf, cursor[1]-1, cursor[1], false, {new_line})
      
      -- Set focus to input window and position cursor
      vim.api.nvim_set_current_win(chat.state.input_win)
      vim.api.nvim_win_set_cursor(chat.state.input_win, {cursor[1], saved_cursor[2] + #filename})
      
      -- Notify about context file
      if added then
        local msg = "**System:** Added file context: " .. file
        chat.append_to_buffer(chat.state.history_buf, vim.api.nvim_buf_line_count(chat.state.history_buf), msg)
        chat.append_to_buffer(chat.state.history_buf, vim.api.nvim_buf_line_count(chat.state.history_buf), "")
      end
      
      -- Ensure we're in insert mode
      vim.cmd("startinsert!")
    end,
    down = '40%'
  })
end

function M.trigger_directory_picker_at_cursor()
  -- Delete the '#' character that was just typed
  local cursor = vim.api.nvim_win_get_cursor(chat.state.input_win)
  local line = vim.api.nvim_buf_get_lines(chat.state.input_buf, cursor[1]-1, cursor[1], false)[1]
  
  local line_before = string.sub(line, 1, cursor[2])
  local line_after = string.sub(line, cursor[2] + 1)
  
  -- Remove the '#' character
  if string.sub(line_before, -1) == '#' then
    line_before = string.sub(line_before, 1, -2)
  end
  
  -- Save cursor position for later
  local saved_cursor = {cursor[1], #line_before}
  
  -- Check if fzf.vim is available
  if vim.fn.exists('*fzf#run') == 0 then
    chat.append_to_buffer(chat.state.history_buf, vim.api.nvim_buf_line_count(chat.state.history_buf), 
      "**System:** FZF not found. Please install fzf.vim")
    return
  end
  
  -- Store window and buffer states to restore them later
  local original_wins = {
    floating_win = chat.state.floating.win,
    input_win = chat.state.input_win,
    input_buf = chat.state.input_buf,
    history_buf = chat.state.history_buf
  }
  
  -- Use FZF to pick a directory
  vim.fn['fzf#run']({
    source = 'find . -type d -not -path "*/node_modules/*" -not -path "*/\\.*" | sort',
    sink = function(directory)
      -- Ensure chat windows are still valid
      local windows_valid = vim.api.nvim_win_is_valid(original_wins.floating_win) and 
                            vim.api.nvim_win_is_valid(original_wins.input_win)
      
      if not windows_valid then
        -- If windows are not valid, reopen the chat
        require('cody_chat.ui').create_split_chat_ui()
      else
        -- Make sure floating window is visible (in case it was hidden)
        vim.api.nvim_win_set_option(original_wins.floating_win, "hidden", false)
        vim.api.nvim_win_set_option(original_wins.input_win, "hidden", false)
      end
      
      -- Get all files in the directory
      local find_cmd = string.format(
        'find "%s" -type f -not -path "*/node_modules/*" -not -path "*/\\.*"', 
        directory:gsub('"', '\\"')
      )
      
      local handle = io.popen(find_cmd)
      if not handle then
        chat.append_to_buffer(chat.state.history_buf, vim.api.nvim_buf_line_count(chat.state.history_buf), 
          "**System:** Error reading directory")
        return
      end
      
      local files = {}
      for file in handle:lines() do
        table.insert(files, file)
      end
      handle:close()
      
      -- Check if there are too many files
      if #files > 20 then
        chat.append_to_buffer(chat.state.history_buf, vim.api.nvim_buf_line_count(chat.state.history_buf), 
          "**System:** Unable to add directory: contains more than 20 files (" .. #files .. " found)")
        chat.append_to_buffer(chat.state.history_buf, vim.api.nvim_buf_line_count(chat.state.history_buf), "")
        
        -- Get directory name without path for insertion
        local dirname = directory:match("([^/]+)$") or directory
        
        -- Update the line with just the directory name (without files)
        local new_line = line_before .. dirname .. " (too many files)" .. line_after
        vim.api.nvim_buf_set_lines(chat.state.input_buf, cursor[1]-1, cursor[1], false, {new_line})
        
        -- Set focus to input window and position cursor
        vim.api.nvim_set_current_win(chat.state.input_win)
        vim.api.nvim_win_set_cursor(chat.state.input_win, {cursor[1], saved_cursor[2] + #dirname + 16})
        
        -- Ensure we're in insert mode
        vim.cmd("startinsert!")
        return
      end
      
      -- Add all files to context
      local added_count = 0
      for _, file in ipairs(files) do
        if M.add_context_file(file) then
          added_count = added_count + 1
        end
      end
      
      -- Get directory name without path for insertion
      local dirname = directory:match("([^/]+)$") or directory
      
      -- Update the line with the directory name
      local new_line = line_before .. dirname .. " (" .. added_count .. " files)" .. line_after
      vim.api.nvim_buf_set_lines(chat.state.input_buf, cursor[1]-1, cursor[1], false, {new_line})
      
      -- Set focus to input window and position cursor
      vim.api.nvim_set_current_win(chat.state.input_win)
      vim.api.nvim_win_set_cursor(chat.state.input_win, {cursor[1], saved_cursor[2] + #dirname + #tostring(added_count) + 9})
      
      -- Notify about context files
      local msg = "**System:** Added directory context: " .. directory .. " (" .. added_count .. " files)"
      chat.append_to_buffer(chat.state.history_buf, vim.api.nvim_buf_line_count(chat.state.history_buf), msg)
      chat.append_to_buffer(chat.state.history_buf, vim.api.nvim_buf_line_count(chat.state.history_buf), "")
      
      -- Ensure we're in insert mode
      vim.cmd("startinsert!")
    end,
    down = '40%'
  })
end

return M
