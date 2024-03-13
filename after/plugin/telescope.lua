local builtin = require('telescope.builtin')

-- keymaps to start telescope
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', builtin.live_grep, {})
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)
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
