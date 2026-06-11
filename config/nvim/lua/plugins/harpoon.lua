local dotfiles = vim.fn.expand("~/dotfiles")
local p = dotfiles .. "/vendor/nvim/plugins"

return {
  {
    dir = p .. "/harpoon",
    dependencies = { { dir = p .. "/plenary.nvim" } },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()

      local map = require('confs.utils').map
      map("n", "<leader>a", function() harpoon:list():append() end, "Harpoon add")
      map("n", "<leader>h", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, "Harpoon menu")
      -- Alt+number to avoid conflict with bufferline's <leader>1-9
      map("n", "<M-1>", function() harpoon:list():select(1) end, "Harpoon 1")
      map("n", "<M-2>", function() harpoon:list():select(2) end, "Harpoon 2")
      map("n", "<M-3>", function() harpoon:list():select(3) end, "Harpoon 3")
      map("n", "<M-4>", function() harpoon:list():select(4) end, "Harpoon 4")
    end,
  },
}
