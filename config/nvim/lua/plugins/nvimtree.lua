return {
  'nvim-tree/nvim-tree.lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  keys = {
    { '<leader>nn', function() require('nvim-tree.api').tree.toggle() end, desc = 'NvimTree toggle'  },
    { '<leader>nf', function() require('nvim-tree.api').tree.focus()  end, desc = 'NvimTree focus'   },
    { '<leader>nr', function() require('nvim-tree.api').tree.reload() end, desc = 'NvimTree refresh' },
  },
  opts = {
    disable_netrw = true,
    renderer = {
      indent_markers = {
        enable = true,
        icons  = { corner = "└ ", edge = "│ ", none = "  " },
      },
    },
    view    = { side = 'left' },
    git     = { enable = false },
    filters = {
      dotfiles = true,
      custom   = { '__pycache__' },
    },
  },
}
