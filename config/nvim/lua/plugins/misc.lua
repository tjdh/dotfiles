return {
  'nvim-lua/plenary.nvim',
  'nvim-tree/nvim-web-devicons',
  'nvim-lua/popup.nvim',
  'dstein64/vim-startuptime',
  'onsails/lspkind.nvim',
  'tpope/vim-fugitive',
  'tpope/vim-abolish',
  'LunarVim/bigfile.nvim',

  {
    'numToStr/Comment.nvim',
    opts = {},
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      scope   = { enabled = false },
      exclude = { filetypes = { "help", "lazy", "mason", "notify", "startify" } },
    },
  },

  {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup(nil, { names = false })
    end,
    keys = {
      { "<leader>co", ":ColorizerToggle<CR>", desc = "Toggle colorizer" },
    },
  },

  {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts  = {},
    lazy  = false,
    keys  = {
      { "<leader>oi", ":Oil<CR>", desc = "Open Oil filetree" },
    },
  },
}
