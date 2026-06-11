return {
  "ray-x/lsp_signature.nvim",
  event = "VeryLazy",
  opts = {
    bind = true,
    doc_lines = 7,
    floating_window = false,
    fix_pos = true,
    hint_enable = true,
    hint_prefix = "> ",
    max_height = 3,
    max_width = 40,
    select_signature_key = "<C-J>",
  },
  keys = {
    { '<C-k>', function() require('lsp_signature').toggle_float_win() end, mode = {'n', 'i'}, desc = "Toggle signature" },
  },
}
