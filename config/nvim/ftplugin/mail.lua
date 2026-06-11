vim.opt_local.spell = true
vim.opt_local.spelllang = 'en_us'
vim.opt_local.fo:append('aw')

vim.api.nvim_buf_set_keymap(0, 'n', '<leader>x', 'ZZ', { noremap = true, silent = true })
