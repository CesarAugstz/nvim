-- This file can be loaded by calling `lua require('plugins')` from your init.vim
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') ..
      '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({
      'git', 'clone', '--depth', '1',
      'https://github.com/wbthomason/packer.nvim', install_path
    })
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    -- or                            , branch = '0.1.x',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }
  use {
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
  }
  use { 'junegunn/fzf', run = function() vim.fn['fzf#install']() end }

  -- colors
  use({ 'catppuccin/nvim', as = 'catppuccin' })
  use({ 'kepano/flexoki-neovim', as = 'flexoki' })
  use({ 'Shatur/neovim-ayu', as = 'ayu' })
  use({ "rose-pine/neovim", as = "rose-pine" })
  use({ "folke/tokyonight.nvim", as = "tokyonight" })
  use({ "rebelot/kanagawa.nvim", as = "kanagawa" })
  use({
    "olivercederborg/poimandres.nvim",
    as = "poimandres",
    config = function() require('poimandres').setup() end
  })
  use({ "dasupradyumna/midnight.nvim" })

  use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })

  -- Repeat
  use 'tpope/vim-repeat'

  use {
    'theprimeagen/harpoon',
    branch = 'harpoon2',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }

  use('nvim-treesitter/playground')
  use('mbbill/undotree')
  use('tpope/vim-fugitive')
  use {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    requires = {
      -- LSP Support
      { 'neovim/nvim-lspconfig' },             -- Required
      { 'williamboman/mason.nvim' },           -- Optional
      { 'williamboman/mason-lspconfig.nvim' }, -- Optional
      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },                  -- Required
      { 'hrsh7th/cmp-nvim-lsp' },              -- Required
      { 'L3MON4D3/LuaSnip' }                   -- Required
    }
  }

  --[[
  -- DAP, Debugger, sem uso no momento
  use 'mfussenegger/nvim-dap'
  use {
    "rcarriga/nvim-dap-ui",
    dependencies = "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end
  }
  use({
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = {
      handlers = {}
    },
  })
  ]]

  use({ 'feline-nvim/feline.nvim' })
  use "Hitesh-Aggarwal/feline_one_monokai.nvim"
  use 'nvim-tree/nvim-web-devicons'

  use({
    "kylechui/nvim-surround",
    tag = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function() require("nvim-surround").setup({}) end
  })

  use({
    'lewis6991/gitsigns.nvim',
    config = function() require('gitsigns').setup() end
  })

  use { 'mhartington/formatter.nvim' }
  use { 'stevearc/conform.nvim' }

  -- https://github.com/nvim-treesitter/nvim-treesitter-context#screenshot
  use('romgrk/nvim-treesitter-context')

  use({
    "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function() require("todo-comments").setup() end
  })

  use({
    "yioneko/nvim-vtsls",
    config = function()
      require("lspconfig.configs").vtsls = require("vtsls").lspconfig
    end
  })

  -- use({
  --   'sourcegraph/sg.nvim',
  --   run = 'nvim -l build/init.lua',
  --   config = function() require('sg').setup() end
  -- })

  use("rhysd/conflict-marker.vim")

  use {
    "Exafunction/codeium.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
    },
    -- config = function()
    --   require("codeium").setup({
    --   })
    -- end
  }

  use({
    "stevearc/oil.nvim",
  })

  use({ 'mg979/vim-visual-multi', branch = 'master' })

  use({
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    tag = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!:).
    run = "make install_jsregexp"
  })

  use({
    'augmentcode/augment.vim',
    config = function()
      vim.g.augment_workspace_folders = { '/home/tyler/dev/sisprevmais-monorepo' }
    end,
  })

  use {
    "garymjr/nvim-snippets",
    config = function()
      -- Configure nvim-snippets
      require('snippets').setup({
        create_autocmd = false,          -- Don't auto-load snippets (nvim-cmp handles this)
        create_cmp_source = true,        -- Create cmp source (default, works with your setup)
        friendly_snippets = true,        -- Set to true if you're using friendly-snippets
        ignored_filetypes = nil,         -- No ignored filetypes
        extended_filetypes = {           -- Load additional snippets for specific filetypes
          typescript = { 'javascript' }, -- Load JS snippets for TS files
          javascriptreact = { 'javascript' },
          typescriptreact = { 'javascript', 'typescript' }
        },
        global_snippets = { 'all' }, -- Snippets available in all filetypes
        search_paths = {             -- Where to look for snippet files
          vim.fn.stdpath('config') .. '/snippets',
          vim.fn.stdpath('data') .. '/site/pack/packer/start/friendly-snippets'
        }
      })
      -- Tab in insert mode - jump forward or fallback to normal Tab
      vim.keymap.set("i", "<Tab>", function()
        if vim.snippet.active({ direction = 1 }) then
          vim.schedule(function()
            vim.snippet.jump(1)
          end)
          return
        end
        return "<Tab>"
      end, { expr = true, silent = true })

      -- Tab in select mode - always jump forward
      vim.keymap.set("s", "<Tab>", function()
        vim.schedule(function()
          vim.snippet.jump(1)
        end)
      end, { expr = true, silent = true })

      -- S-Tab in insert and select modes - jump backward or fallback
      vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
        if vim.snippet.active({ direction = -1 }) then
          vim.schedule(function()
            vim.snippet.jump(-1)
          end)
          return
        end
        return "<S-Tab>"
      end, { expr = true, silent = true })
    end
  }

  use {
    'michaelrommel/nvim-silicon',
    cmd = 'Silicon',
    config = function()
      require("nvim-silicon").setup({
        to_clipboard = true,
        theme = "Dracula",
        output = function()
          return "./" .. os.date("%Y-%m-%dT%H-%M-%S") .. "_code.png"
        end,
        background = "#FFFFFF",
        language = function()
          local filetype = vim.bo.filetype
          print("filetype: " .. filetype)
          if filetype == nil or filetype == "" then
            local ext = vim.fn.fnamemodify(
              vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()),
              ":e"
            )
            print("ext: " .. ext)
            if ext == "zmodel" then
              return "dart"
            end
            return ext
          end
          if filetype == "zmodel" then
            return "dart"
          end
          return vim.bo.filetype
        end,
        window_title = function()
          return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t")
        end,
      })
    end
  }


  if packer_bootstrap then require('packer').sync() end
end)
