local dotfiles = vim.fn.expand("~/dotfiles")
local lazypath = dotfiles .. "/vendor/nvim/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({ "timeout", "3", "git", "ls-remote", "https://github.com/folke/lazy.nvim.git" })
    if vim.v.shell_error == 0 then
      vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
    else
      vim.notify(
        "lazy.nvim missing and GitHub unreachable -- plugins not loaded.\n"
        .. "Restore vendor/nvim/lazy.nvim from a machine with the config, then restart.",
        vim.log.levels.WARN)
      return
    end
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  defaults = { lazy = false },
  root = dotfiles .. "/vendor/nvim/plugins",
  git = { cooldown = 0 },
  checker = { enabled = false },
  change_detection = { enabled = false },
  rocks = { enabled = false },
  install = { missing = false },
})

local map = require('confs.utils').map
map('n', '<leader>la', '<cmd>Lazy<CR>', "Open Lazy manager")
