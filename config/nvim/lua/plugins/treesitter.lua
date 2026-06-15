return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'master',
    main = 'nvim-treesitter.configs',
    opts = {
      ensure_installed = {
        'python', 'c', 'cpp', 'bash', 'lua',
        'json', 'yaml', 'toml', 'markdown', 'markdown_inline',
        'vim', 'vimdoc', 'query',
      },
      sync_install = false,
      highlight = { enable = true },
      indent    = { enable = true },
    },
  },
}
