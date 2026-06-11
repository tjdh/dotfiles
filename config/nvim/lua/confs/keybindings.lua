local map = require('confs.utils').map
local silent_opt = {silent = true}

map('n', 'j', 'gj')
map('n', 'k', 'gk')

vim.keymap.set('n', '<CR>', function()
  if vim.bo.buftype ~= '' then
    return '<CR>'
  end
  return 'm`o<Esc>``'
end, { expr = true, silent = true })

vim.keymap.set('n', '<S-CR>', function()
  if vim.bo.buftype ~= '' then
    return '<S-CR>'
  end
  return 'm`O<Esc>``'
end, { expr = true, silent = true })

map('n', '<leader>qh', '<cmd>noh<CR>', 'Quiet highlight', silent_opt)
map('n', '<leader>nw', '<cmd>set wrap!<CR>', 'Toggle wrap', silent_opt)
map('n', '<leader>hi', vim.show_pos, 'Inspect under cursor')
map('n', '<leader>sv', '<cmd>source $MYVIMRC<CR>', 'Source vimrc')
map('n', '<leader>so', '<cmd>source %<CR>', 'Source current file')
map('n', '<leader>st', '<cmd>% s#\\s\\+$##e<CR>:w<CR>', 'Strip trailing whitespace')
map('n', '<leader>sm', ':%s/\\r//g<CR>', 'Remove carriage returns')
map('n', '<leader>ya', "mmggVGy'm", 'Yank entire file')
map('n', '<leader>cd', '<cmd>cd %:p:h<CR>', 'cd to current file dir')

map('n', '<leader>lc', '<cmd>lclose<CR>', 'Close loclist')
map('n', '<leader>qc', '<cmd>cclose<CR>', 'Close quickfixlist')

map('v', '<leader>ct', ':!column -t<CR>gv>', 'Column table')
map('v', 'K', ":m '<-2<CR>gv=gv", 'Move line up', silent_opt)
map('v', 'J', ":m '>+1<CR>gv=gv", 'Move line down', silent_opt)

vim.keymap.set('x', 'p', 'P')
vim.keymap.set('x', 'P', 'p')

map('n', '<leader>js', ":s/'/\"/ge | s/False/false/ge | s/True/true/ge | s/None/null/ge<CR>", "Convert to json")
map('v', '<leader>js', ":g/^/ s#'#\"#ge | s#False#false#ge | s#True#true#ge | s#None#null#ge<CR>", "Convert to json")
map('v', '<leader>jp', ":g/^/ s#\"#'#ge | s#false#False#ge | s#true#True#ge | s#null#None#ge<CR>", "Convert json to python")

map({'n','v'}, '<leader>bh', '"_d', 'Blackhole register')
map('n', '<leader>gb', '<cmd>Git blame<CR>', 'Git blame')
map({'n','i'}, '<F1>', '<NOP>', 'Unmap F1')
map('n', '<leader>hw', ":let @/='\\<<C-R><C-W>\\>'<CR>:set hls<CR>", 'Highlight word under cursor')
