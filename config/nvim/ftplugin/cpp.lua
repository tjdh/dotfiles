local buf_map = require('confs.utils').buf_map
buf_map('n', '<leader>rr', ':w<CR>:!g++ -std=c++17 -o /tmp/%:r % && /tmp/%:r<CR>', 'Compile and run')
