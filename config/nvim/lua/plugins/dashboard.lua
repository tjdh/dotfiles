return {
  {
    'mhinz/vim-startify',
    config = function()
      vim.g.startify_lists = {
        { type = 'bookmarks', header = { '   Bookmarks' } },
        { type = 'sessions',  header = { '   Sessions'  } },
        { type = 'files',     header = { '   Files'     } },
        { type = 'dir',       header = { '   Files ' .. vim.fn.getcwd() } },
        { type = 'commands',  header = { '   Commands'  } },
      }
      local map = require('confs.utils').map
      map('n', '<leader>sa', '<CMD>Startify<CR>', "Start page")
    end,
  },
}
