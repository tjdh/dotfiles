return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'master',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs',
    opts = {
      ensure_installed = {},
      sync_install = false,
      highlight = { enable = true },
      indent    = { enable = true },
    },
  },
}
