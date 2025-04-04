-- This file serves as the entry point for the modular Cody Chat implementation
-- It loads the required modules and sets up the commands and keymappings

-- First, let's remove any circular dependencies by pre-declaring the state
_G.cody_chat_state = {
  floating = {
    buf = -1,
    win = -1,
  },
  input_buf = -1,
  input_win = -1,
  history_buf = -1,
  context_files = {},
}

-- Now load the modules
local ui = require('cody_chat.ui')
local commands = require('cody_chat.commands')

-- Create commands and keymappings
vim.api.nvim_create_user_command("CodyChat", ui.toggle_cody_chat, {})
vim.keymap.set("n", "<leader>cc", ":CodyChat<CR>", {silent = true})

-- Expose command processing to global space for keymappings in UI
_G.cody_chat_process_input = commands.process_input
