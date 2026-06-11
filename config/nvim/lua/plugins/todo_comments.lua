local map = require('confs.utils').map

return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local tc = require("todo-comments")
    tc.setup({ signs = false })
    map('n', ']t', tc.jump_next, 'Next todo comment')
    map('n', '[t', tc.jump_prev, 'Prev todo comment')
  end,
}
