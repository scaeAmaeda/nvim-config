-- Chemin pour lazy.nvim (gestionnaire de plugins)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Plugins
require("lazy").setup({
  { "nvim-lualine/lualine.nvim" },
  { "nvim-tree/nvim-web-devicons", lazy = true },
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  { "neovim/nvim-lspconfig" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-path" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "folke/tokyonight.nvim",lazy = false,priority = 1000,
  config = function()
    vim.cmd.colorscheme("tokyonight")
  end,
  },
  {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = true,
  },
  {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- pour les icônes
  config = function()
    require("nvim-tree").setup({
      view = {
        width = 30,
        side = "left",
        relativenumber = true,
      },
      renderer = {
        highlight_git = true,
        icons = {
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = true,
          },
        },
      },
      git = {
        enable = true,
        ignore = false,
      },
      filters = {
        dotfiles = false,
      },
    })
  end,
  },
  {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({
      open_mapping = [[<leader>tt]],
      direction = "horizontal", -- "float", "vertical", "tab"
      start_in_insert = true,
      insert_mappings = true,
      terminal_mappings = true,
      persist_size = true,
      close_on_exit = true,
      shell = vim.o.shell,
    })
  end,
  },
  {
    "neoclide/coc.nvim",
    branch = "release",
    build = "npm ci",
  },
})

-- Définition du leader avant tout mapping
vim.g.mapleader = " "

-- Options de base
vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = "a"
vim.o.clipboard = "unnamedplus"
vim.o.termguicolors = true
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2

-- Lualine
require('lualine').setup()

-- Telescope
require('telescope').setup({
  defaults = {
    file_ignore_patterns = {
      "%bin\\",
      "%obj\\",
      "node_modules\\",
      "%.git",
    },
  },
})
vim.keymap.set('n', '<C-p>', require('telescope.builtin').find_files, {})
vim.keymap.set('n', '<C-f>', require('telescope.builtin').live_grep, {})

-- Treesitter
require('nvim-treesitter.configs').setup {
  ensure_installed = { "go", "c_sharp", "html", "css", "javascript", "lua" },
  highlight = { enable = true },
  indent = { enable = true },
}

-- LSP
local lspconfig = require('lspconfig')
lspconfig.gopls.setup {}
lspconfig.omnisharp.setup {
  cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
}
lspconfig.html.setup {}
lspconfig.cssls.setup {}
lspconfig.ts_ls.setup {}

-- Completion
local cmp = require('cmp')
cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' },
  },
})

-- LSP Keymaps
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {})
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {})

-- Telescope keys
local builtin = require("telescope.builtin")
local keymap = vim.keymap
keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope: find files" })
keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope: live grep" })
keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope: buffers" })
keymap.set("n", "<leader>d", ":Telescope diagnostics<CR>", { noremap = true, silent = true })
-- (ici le folder de gauche plutôt)
keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file tree" })
-- (ici le terminal integre)
keymap.set("n", "<leader>tt", "<cmd>ToggleTerm<CR>", { desc = "🖥️ Terminal toggle" })
