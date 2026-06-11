return {
  'akinsho/toggleterm.nvim',
  opts = {
    size = function(term)
      if term.direction == "horizontal" then
        return 18
      elseif term.direction == "vertical" then
        return vim.o.columns * 0.4
      end
    end,
    open_mapping = [[<c-\>]],
    direction = 'vertical',
  },
}
