local buf_map = require('confs.utils').buf_map
buf_map('n', '<leader>rr', ':w<CR>:!./%<CR>', 'Execute file')
