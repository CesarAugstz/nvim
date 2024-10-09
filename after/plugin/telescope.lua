local builtin = require('telescope.builtin')

local actions = require('telescope.actions')

require('telescope').setup {
  mappings = {
    i = {
      ["<RightMouse>"] = actions.close,
      ["<LeftMouse>"] = actions.select_default,
      ["<ScrollWheelDown>"] = actions.move_selection_next,
      ["<ScrollWheelUp>"] = actions.move_selection_previous,
    },
    n = {
    },

  },
  extensions = {
    fzf = {
      fuzzy = true,                   -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true,    -- override the file sorter
      case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    }
  }
  --  extensions = {
  --    fzy_native = {
  --      override_generic_sorter = true,
  --      override_file_sorter = true,
  --    },

  --    fzf_writer = {
  --      use_highlighter = false,
  --      minimum_grep_characters = 6,
  --    },
  --  },
}

require('telescope').load_extension 'fzf'

-- keymaps to start telescope
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', builtin.live_grep, {})
-- vim.keymap.set('n', '<leader>ps', function()
--   builtin.grep_string({ search = vim.fn.input("Grep > ") });
-- end)
vim.keymap.set('n', '<leader>pws', function()
  local word = vim.fn.expand("<cword>")
  builtin.grep_string({ search = word })
end)
vim.keymap.set('n', '<leader>pWs', function()
  local word = vim.fn.expand("<cWORD>")
  builtin.grep_string({ search = word })
end)
vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>pb', builtin.buffers, {})
vim.keymap.set('n', '<leader>pr', builtin.resume, {})
vim.keymap.set('n', '<leader>pcb', builtin.current_buffer_fuzzy_find, {})

-- telescope config
-- tvz n precise pq esta com wordwrap
-- require('telescope').setup {
--     defaults = {
--         mappings = {
--             n = {
--                 ["H"] = "preview_scrolling_right",
--                 ["L"] = "preview_scrolling_left",
--             },
--         },
--     }
-- }
