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
      { 'L3MON4D3/LuaSnip' },     -- Required
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
})


require('bufferline-config')
require('telescope-config')
require('gopls')
require('language-config')

local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(client, bufnr)
  local opts = { buffer = bufnr }
  lsp.default_keymaps(opts)
  lsp.async_autoformat(client, bufnr)
end)

require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

lsp.setup()

vim.cmd('Copilot disable')

vim.opt.background = 'light'
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
