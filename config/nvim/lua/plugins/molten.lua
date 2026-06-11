return {
  {
    "benlubas/molten-nvim",
    version = "^1.0.0",
    build = ":UpdateRemotePlugins",
    dependencies = { "image.nvim" },
    init = function()
      vim.g.molten_image_provider = "image.nvim"
    end,
  },
  {
    "3rd/image.nvim",
    name = "image.nvim",
    config = function()
      -- WSL2 + tmux: $TMUX may be unset over SSH; force tmux passthrough mode
      -- so Kitty/iTerm2 image escapes get wrapped in DCS and survive the hop.
      local ok, tmux_utils = pcall(require, "image.utils.tmux")
      if ok then
        tmux_utils.is_tmux = true
        tmux_utils.has_passthrough = true
      end
      require("image").setup({
        backend  = "iterm2",
        processor = "magick_cli",
        tmux_show_only_in_active_window = false,
      })
    end,
  },
  {
    "GCBallesteros/jupytext.nvim",
    config = true,
  },
}
