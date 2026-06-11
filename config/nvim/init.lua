require('confs.options')
require('confs.keybindings')
require('confs.lazy')

-- Kill xsel on exit (avoids zombie clipboard processes)
vim.api.nvim_create_autocmd("VimLeave", {
  group = vim.api.nvim_create_augroup("KillXSel", { clear = true }),
  callback = function() os.execute("killall xsel") end,
})

-- Restore last cursor position when reopening a file
local lastplace = vim.api.nvim_create_augroup("LastPlace", {})
vim.api.nvim_clear_autocmds({ group = lastplace })
vim.api.nvim_create_autocmd("BufWinEnter", {
  group   = lastplace,
  pattern = "*",
  command = "silent! normal! g`\"zv",
})

-- Emacs-style line start/end
vim.keymap.set({'n','v','o'}, '<C-a>', '^')
vim.keymap.set({'n','v','o'}, '<C-e>', '$')
vim.keymap.set('i', '<C-a>', '<C-o>^')
vim.keymap.set('i', '<C-e>', '<End>')

-- Visual surround shortcuts
vim.keymap.set('v', '(',  'c()<Esc>P')
vim.keymap.set('v', '[',  'c[]<Esc>P')
vim.keymap.set('v', '{',  'c{}<Esc>P')
vim.keymap.set('v', '"',  'c""<Esc>P')
vim.keymap.set('v', "'", "c''<Esc>P")

-- OSC 52 clipboard passthrough (SSH sessions only)
if vim.fn.has('nvim-0.10') == 1 and vim.env.SSH_TTY then
  vim.g.clipboard = {
    name  = 'OSC 52 (copy only)',
    copy  = {
      ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
      ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
    },
    paste = {
      ['+'] = function() return { vim.fn.split(vim.fn.getreg(''), '\n'), vim.fn.getregtype('') } end,
      ['*'] = function() return { vim.fn.split(vim.fn.getreg(''), '\n'), vim.fn.getregtype('') } end,
    },
  }
end

-- Molten globals (these override any settings in the plugin spec's init)
vim.g.molten_output_win_max_height = 20
vim.g.molten_virt_text_output      = true
vim.g.molten_virt_lines_off_by_1   = true
vim.g.molten_auto_open_output      = false
vim.g.molten_wrap_output           = true

local function molten_eval_cell()
  local line = vim.fn.line('.')
  local last = vim.fn.line('$')
  local start_line = 1
  for i = line, 1, -1 do
    if vim.fn.getline(i):match('^%s*#%s*%%%%') then
      start_line = i + 1
      break
    end
  end
  local next_cell_line = nil
  for i = line + 1, last do
    if vim.fn.getline(i):match('^%s*#%s*%%%%') then
      next_cell_line = i
      break
    end
  end
  local end_line = next_cell_line and (next_cell_line - 1) or last
  vim.fn.MoltenEvaluateRange(start_line, end_line)
  if next_cell_line then
    vim.api.nvim_win_set_cursor(0, { math.min(next_cell_line + 1, vim.fn.line('$')), 0 })
  else
    vim.api.nvim_buf_set_lines(0, end_line, end_line, false, { '', '# %%', '' })
    vim.api.nvim_win_set_cursor(0, { end_line + 3, 0 })
  end
end

vim.keymap.set('n', '<leader>mi', ':MoltenInit<CR>',                    { desc = 'Molten: init kernel'             })
vim.keymap.set('n', '<leader>ml', ':MoltenEvaluateLine<CR>',            { desc = 'Molten: eval line'              })
vim.keymap.set('v', '<leader>mr', ':<C-u>MoltenEvaluateVisual<CR>gv',   { desc = 'Molten: eval visual'            })
vim.keymap.set('n', '<leader>mo', ':MoltenShowOutput<CR>',              { desc = 'Molten: show output'            })
vim.keymap.set('n', '<leader>mh', ':MoltenHideOutput<CR>',              { desc = 'Molten: hide output'            })
vim.keymap.set('n', '<leader>md', ':MoltenDelete<CR>',                  { desc = 'Molten: delete cell'            })
vim.keymap.set('n', '<leader>me', function()
  vim.cmd('MoltenShowOutput')
  vim.schedule(function() vim.cmd('noautocmd MoltenEnterOutput') end)
end, { desc = 'Molten: show + enter output' })
vim.keymap.set('n', '<leader>mc', molten_eval_cell,                     { desc = 'Molten: eval cell'              })
vim.keymap.set('n', '<S-CR>',     molten_eval_cell,                     { desc = 'Molten: eval cell (Shift+Enter)'})

vim.keymap.set('n', ']c',       function() vim.fn.search('^\\s*#\\s*%%', 'W')  end, { desc = 'Next cell'         })
vim.keymap.set('n', '[c',       function() vim.fn.search('^\\s*#\\s*%%', 'bW') end, { desc = 'Prev cell'         })
vim.keymap.set('n', '<C-Down>', function() vim.fn.search('^\\s*#\\s*%%', 'W')  end, { desc = 'Next cell (Ctrl+↓)'})
vim.keymap.set('n', '<C-Up>',   function() vim.fn.search('^\\s*#\\s*%%', 'bW') end, { desc = 'Prev cell (Ctrl+↑)'})
