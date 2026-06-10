vim.g.mapleader = " "

-- UI
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Indentation (4 spaces)
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.smartindent = true
vim.opt.autoindent = true

-- Lazy.nvim bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

  { "nvim-lua/plenary.nvim" },

  -- Theme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        term_colors = true,
        styles = {
          comments = { "italic" },
          keywords = { "italic" },
          conditionals = { "italic" },
          loops = { "italic" },
        },
        integrations = {
          telescope = true,
        },
        custom_highlights = function(colors)
          return {
            String = { fg = colors.yellow },
            Character = { fg = colors.yellow },
            Number = { fg = colors.peach },
            Boolean = { fg = colors.peach },
            Function = { fg = colors.blue },
            Keyword = { fg = colors.mauve, italic = true },
            Type = { fg = colors.yellow },
            Constant = { fg = colors.peach },
          }
        end,
      })

      vim.cmd.colorscheme("catppuccin")

      -- ensure strings aren't green
      vim.api.nvim_set_hl(0, "@string", { fg = "#f9e2af" })
      vim.api.nvim_set_hl(0, "@character", { fg = "#f9e2af" })
    end,
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  -- Harpoon
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  -- Autopairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },

  { "nvim-tree/nvim-web-devicons" },

  -- Dashboard with cow
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    config = function()
      local dashboard = require("dashboard")

      local function cow_fortune()
        local fortune = vim.fn.systemlist("fortune -s")
        local text = table.concat(fortune, " "):gsub("'", [["'"']])
        local cow = vim.fn.systemlist("printf '%s' '" .. text .. "' | cowsay -W 40")

        local max_len = 0
        for _, line in ipairs(cow) do
          if #line > max_len then
            max_len = #line
          end
        end

        for i, line in ipairs(cow) do
          cow[i] = line .. string.rep(" ", max_len - #line)
        end

        return cow
      end

      dashboard.setup({
        theme = "doom",
        config = {
          header = cow_fortune(),
          center = {
            {
              icon = " ",
              desc = "Find files",
              key = "ff",
              action = "lua require('telescope.builtin').find_files()",
            },
            {
              icon = " ",
              desc = "Live grep",
              key = "ag",
              action = "lua require('telescope.builtin').live_grep()",
            },
          },
        },
      })
    end,
  },
})

-- Harpoon keybinds
local harpoon = require("harpoon")
harpoon:setup()

vim.keymap.set("n", "<leader>a", function()
  harpoon:list():append()
end)

vim.keymap.set("n", "<leader>h", function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end)

vim.keymap.set("n", "<leader>1", function()
  harpoon:list():select(1)
end)

vim.keymap.set("n", "<leader>2", function()
  harpoon:list():select(2)
end)

vim.keymap.set("n", "<leader>3", function()
  harpoon:list():select(3)
end)

vim.keymap.set("n", "<leader>4", function()
  harpoon:list():select(4)
end)

-- Background
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none"})
