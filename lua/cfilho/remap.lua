vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", "<cmd>Oil<CR>")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
-- vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- format default nvim
vim.keymap.set("n", "<leader>f", "<cmd>Format<CR>")
vim.keymap.set("n", "<leader>F", "<cmd>EslintFixAll<CR>")

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })


vim.keymap.set("n", "<leader><leader>", function()
  vim.cmd("so")
end)


--[[ My remaps ]] --

vim.keymap.set("n", "<leader>on", "<cmd>only<CR>")


-- buffers
vim.keymap.set("n", "<leader>w", "<cmd>bnext<CR>")

-- todo
vim.keymap.set("n", "[t", function()
  require("todo-comments").jump_prev()
end, { desc = "Previous todo comment" })

-- You can also specify a list of valid jump keywords

vim.keymap.set("n", "]t", function()
  require("todo-comments").jump_next()
end, { desc = "Next todo comment" })

vim.keymap.set("i", "<C-BS>", "<C-w>")

vim.keymap.set("n", "[w", function()
  require("treesitter-context").go_to_context(vim.v.count1)
end, { silent = true })


vim.keymap.set("n", "ya", "mzggVGy`z")
vim.keymap.set("n", "<leader>ya", 'mzggVG"+y`zzz')

vim.keymap.set("n", "<leader>td", "<cmd>e ~/todo.md<CR>")
vim.keymap.set("n", "<leader>gr", "<cmd>Telescope lsp_references<CR>")

vim.keymap.set("n", "<leader>/", [[/\c<Left><Left>]])
