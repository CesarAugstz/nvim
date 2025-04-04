local M = {}

-- Use the globally defined state to avoid circular dependencies
M.state = _G.cody_chat_state

function M.create_floating_window(opts)
  opts = opts or {}
  local width = opts.width or math.floor(vim.o.columns * 0.8)
  local height = opts.height or math.floor(vim.o.lines * 0.8)

  -- Calculate the position to center the window
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  -- Create a buffer
  local buf = nil
  if opts.buf and vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer
  end

  -- Define window configuration
  local win_config = {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal",
    border = "rounded",
    title = "Cody Chat",
    title_pos = "center",
  }

  -- Create the floating window
  local win = vim.api.nvim_open_win(buf, true, win_config)

  -- Set window options
  vim.api.nvim_win_set_option(win, "winhighlight", "Normal:Normal,FloatBorder:FloatBorder")
  
  return { buf = buf, win = win }
end

-- Helper function to safely append text to buffer
function M.append_to_buffer(buf, line_start, text)
  -- Split text into separate lines if it contains newlines
  local lines = {}
  for line in (text .. "\n"):gmatch("(.-)\n") do
    table.insert(lines, line)
  end
  
  -- Now safely append these lines to the buffer
  vim.api.nvim_buf_set_lines(buf, line_start, line_start, false, lines)
  return line_start + #lines
end

function M.execute_cody_command(prompt)
  -- Append user message to history
  local current_lines = vim.api.nvim_buf_line_count(M.state.history_buf)
  current_lines = M.append_to_buffer(M.state.history_buf, current_lines, "**You:** " .. prompt)
  current_lines = M.append_to_buffer(M.state.history_buf, current_lines, "")
  
  -- Add a loading indicator
  current_lines = M.append_to_buffer(M.state.history_buf, current_lines, "**Cody:** _thinking..._")
  local loading_line = current_lines - 1
  
  -- Build command based on context
  local cmd = "cody chat -m '" .. prompt:gsub("'", "'\\''") .. "'"
  
  -- Add file contexts if available
  local context_args = ""
  for _, file in ipairs(M.state.context_files) do
    context_args = context_args .. " --context-file '" .. file:gsub("'", "'\\''") .. "'"
  end
  
  cmd = cmd .. context_args
  
  -- Execute command in background
  vim.fn.jobstart(cmd, {
    on_stdout = function(_, data)
      if data and #data > 0 then
        vim.schedule(function()
          -- Remove the loading indicator on first output
          if loading_line >= 0 then
            vim.api.nvim_buf_set_lines(M.state.history_buf, loading_line, loading_line + 1, false, {"**Cody:**"})
            loading_line = -1
            
            -- Process and append output
            local line_count = vim.api.nvim_buf_line_count(M.state.history_buf)
            local response_text = table.concat(data, "\n")
            M.append_to_buffer(M.state.history_buf, line_count, response_text)
            
            -- Scroll to the bottom
            vim.api.nvim_win_set_cursor(M.state.floating.win, {vim.api.nvim_buf_line_count(M.state.history_buf), 0})
          else
            -- Append additional output
            local line_count = vim.api.nvim_buf_line_count(M.state.history_buf)
            local response_text = table.concat(data, "\n")
            M.append_to_buffer(M.state.history_buf, line_count, response_text)
            
            -- Scroll to the bottom
            vim.api.nvim_win_set_cursor(M.state.floating.win, {vim.api.nvim_buf_line_count(M.state.history_buf), 0})
          end
        end)
      end
    end,
    on_exit = function()
      vim.schedule(function()
        -- If loading indicator is still there, remove it (no output case)
        if loading_line >= 0 then
          vim.api.nvim_buf_set_lines(M.state.history_buf, loading_line, loading_line + 1, false, {"**Cody:** _No response_"})
        end
        
        -- Add an empty line after the response
        local line_count = vim.api.nvim_buf_line_count(M.state.history_buf)
        M.append_to_buffer(M.state.history_buf, line_count, "")
        
        -- Focus back to input window and clear it
        vim.api.nvim_set_current_win(M.state.input_win)
        vim.api.nvim_buf_set_lines(M.state.input_buf, 0, -1, false, {""})
        vim.cmd("startinsert")
      end)
    end
  })
end

return M
