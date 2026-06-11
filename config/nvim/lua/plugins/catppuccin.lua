local dotfiles = vim.fn.expand("~/dotfiles")

return {
  {
    dir = dotfiles .. "/vendor/nvim/plugins/catppuccin",
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
          telescope  = true,
          bufferline = true,
        },
        custom_highlights = function(colors)
          return {
            String    = { fg = colors.yellow },
            Character = { fg = colors.yellow },
            Number    = { fg = colors.peach },
            Boolean   = { fg = colors.peach },
            Function  = { fg = colors.blue },
            Keyword   = { fg = colors.mauve, italic = true },
            Type      = { fg = colors.yellow },
            Constant  = { fg = colors.peach },
          }
        end,
      })

      vim.cmd.colorscheme("catppuccin")

      vim.api.nvim_set_hl(0, "@string",    { fg = "#f9e2af" })
      vim.api.nvim_set_hl(0, "@character", { fg = "#f9e2af" })

      for _, group in ipairs({
        "Normal", "NormalNC", "NormalFloat", "EndOfBuffer",
        "SignColumn", "LineNr", "CursorLineNr", "FoldColumn",
        "Folded", "NonText", "WinSeparator", "VertSplit",
      }) do
        vim.api.nvim_set_hl(0, group, { bg = "none", ctermbg = "none" })
      end

      -- Subtle cursorline rather than the heavy catppuccin default
      vim.api.nvim_set_hl(0, "CursorLine", { bg = "#313244" })
    end,
  },
}
