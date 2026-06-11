local dotfiles = vim.fn.expand("~/dotfiles")

return {
  {
    dir = dotfiles .. "/vendor/nvim/plugins/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require('nvim-autopairs').setup({})
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      require('cmp').event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end,
  },
}
