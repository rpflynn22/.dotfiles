vim.g.mapleader = ","
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

-- Auto-install lazy.nvim if not present
if not vim.loop.fs_stat(lazypath) then
  print('Installing lazy.nvim....')
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
  print('Done.')
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  { 'christoomey/vim-tmux-navigator' },
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    dependencies = {
      -- LSP Support
      { 'neovim/nvim-lspconfig' }, -- Required
      {                            -- Optional
        'williamboman/mason.nvim',
        build = function()
          pcall(vim.cmd, 'MasonUpdate')
        end,
      },
      { 'williamboman/mason-lspconfig.nvim' }, -- Optional

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },     -- Required
      { 'hrsh7th/cmp-nvim-lsp' }, -- Required
      {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        build = "make install_jsregexp"
      }
    }
  },
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
  },
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.2',
    dependencies = { 'nvim-lua/plenary.nvim', 'BurntSushi/ripgrep' }
  },
  {
    "danielfalk/smart-open.nvim",
    branch = "0.2.x",
    config = function()
      require("telescope").load_extension("smart_open")
    end,
    dependencies = {
      "kkharji/sqlite.lua",
      -- Only required if using match_algorithm fzf
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      -- Optional.  If installed, native fzy will be used when match_algorithm is fzy
      { "nvim-telescope/telescope-fzy-native.nvim" },
    },
  },
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {} -- this is equalent to setup({}) function
  },
  {
    'github/copilot.vim',
  },
  {
    'unblevable/quick-scope',
  },
  {
    'stevearc/oil.nvim',
    opts = {},
    dependencies = { "nvim-tree/nvim-web-devicons" },
  }
})


require('bufferline-config')
require('telescope-config')
require('gopls')
require('language-config')
require("oil_config")

local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(client, bufnr)
  local opts = { buffer = bufnr }
  lsp.default_keymaps(opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  lsp.async_autoformat(client, bufnr)
end)

require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())
require('lspconfig').jsonls.setup({})

lsp.setup()

-- Diagnostic configuration: show full errors in floating windows
vim.diagnostic.config({
  virtual_text = false,
  float = {
    border = "rounded",
    source = true,
  },
})

-- Show diagnostics on cursor hold
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, { focus = false })
  end,
})

-- Diagnostic navigation keymaps
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)

vim.cmd('Copilot disable')

--vim.opt.background = 'light'
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.keymap.set('i', 'jk', '<esc>', { noremap = true })
vim.keymap.set('n', '<leader>w', ':bd<cr>', { noremap = true })
vim.keymap.set('n', 'gt', ':bnext<cr>', { noremap = true })
vim.keymap.set('n', 'gT', ':bprevious<cr>', { noremap = true })

-- Colors
-- TODO: move
vim.api.nvim_set_hl(0, 'Identifier', { fg = 'black' })
vim.api.nvim_set_hl(0, 'Include', { fg = 'green', italic = true })
vim.api.nvim_set_hl(0, 'Function', { fg = 'RoyalBlue4', italic = true })
vim.api.nvim_set_hl(0, 'Comment', { fg = 'DeepSkyBlue', italic = true })
vim.api.nvim_set_hl(0, 'Type', { fg = 'DarkSlateGray', bold = true })
vim.api.nvim_set_hl(0, 'String', { fg = 'green' })
vim.api.nvim_set_hl(0, 'QuickScopePrimary', { underline = true })
vim.api.nvim_set_hl(0, 'QuickScopeSecondary', { underline = true })
