local map = require('confs.utils').map

return {
  {
    'akinsho/bufferline.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local bufferline = require('bufferline')
      bufferline.setup({
        highlights = {
          fill              = { bg = "none" },
          background        = { bg = "none" },
          tab               = { bg = "none" },
          tab_close         = { bg = "none" },
          close_button      = { bg = "none" },
          separator         = { bg = "none" },
          indicator_visible = { bg = "none" },
          buffer_visible    = { bg = "none" },
          modified          = { bg = "none" },
          modified_visible  = { bg = "none" },
          duplicate         = { bg = "none" },
          duplicate_visible = { bg = "none" },
        },
      })

      for idx = 1, 9 do
        map('n', '<leader>'..idx, function() bufferline.go_to(idx) end, 'Goto buffer '..idx)
      end
      map('n', ']b', function() bufferline.cycle(1)  end, 'Next buffer')
      map('n', '[b', function() bufferline.cycle(-1) end, 'Prev buffer')
      map('n', '<leader>bn', function() bufferline.move(1)  end, 'Move buffer next')
      map('n', '<leader>bN', function() bufferline.move(-1) end, 'Move buffer prev')
      map('n', '<leader>bp', '<cmd>BufferLineTogglePin<CR>', 'Pin buffer')
      map('n', '<leader>bs', function() bufferline.sort_by('directory') end, 'Sort buffers by directory')
    end,
  },
}
