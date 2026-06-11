return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'master',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs',
    opts = {
      ensure_installed = {
        'lua', 'bash', 'c', 'cpp', 'python',
        'json', 'toml', 'markdown', 'vim', 'vimdoc', 'csv',
      },
      sync_install = false,
      highlight = { enable = true },
      indent    = { enable = true },
    },
  },
}
