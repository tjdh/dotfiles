local dotfiles = vim.fn.expand("~/dotfiles")
local p = dotfiles .. "/vendor/nvim/plugins"

return {
  {
    dir = p .. "/telescope.nvim",
    dependencies = {
      { dir = p .. "/plenary.nvim" },
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    config = function()
      local telescope = require('telescope')
      local actions   = require('telescope.actions')
      local builtin   = require('telescope.builtin')
      local utils     = require('confs.utils')

      telescope.setup{
        defaults = {
          prompt_prefix = "   ",
          results_title = false,
          layout_strategy = 'horizontal',
          layout_config = {
            width = 0.9,
            preview_width = 0.47,
          },
          file_ignore_patterns = { "__pycache__/" },
          mappings = {
            i = {
              ["<c-j>"] = actions.move_selection_next,
              ["<c-k>"] = actions.move_selection_previous,
            },
            n = {
              ["<c-j>"] = actions.move_selection_next,
              ["<c-k>"] = actions.move_selection_previous,
            },
          },
          vimgrep_arguments = {
            "rg", "--color=never", "--no-heading",
            "--with-filename", "--line-number", "--column", "--smart-case",
          },
        },
      }

      telescope.load_extension('fzf')

      local function find_files_from_git_root()
        local opts = utils.is_git_repo() and { cwd = utils.get_git_root() } or {}
        builtin.find_files(opts)
      end

      local function live_grep_from_git_root()
        local opts = { path_display = {'tail'} }
        if utils.is_git_repo() then
          opts = vim.tbl_extend("keep", opts, { cwd = utils.get_git_root() })
        end
        builtin.live_grep(opts)
      end

      local map = utils.map
      map('n', '<leader>ft', builtin.builtin,              'Telescope pickers')
      map('n', '<leader>ff', find_files_from_git_root,     'Find files')
      map('n', '<leader>fl', function() builtin.find_files{ cwd = vim.fn.getcwd() } end, 'Find files (cwd)')
      map('n', '<leader>ag', live_grep_from_git_root,      'Live grep')
      map('n', '<leader>fb', builtin.buffers,              'Buffers')
      map('n', '<leader>fh', builtin.help_tags,            'Help tags')
      map('n', '<leader>fo', builtin.vim_options,          'Vim options')
      map('n', '<leader>fv', function() builtin.find_files{ cwd = "~/.config/nvim", prompt_title = "Nvim Config" } end, 'Nvim config')
      map('n', '<leader>fc', builtin.current_buffer_fuzzy_find, 'Buffer search')
      map('n', '<leader>aw', function() builtin.grep_string{ initial_mode = "normal" } end, 'Grep word under cursor')
      map('n', '<leader>fr', function() builtin.resume{ initial_mode = "normal" } end, 'Resume last picker')
      map('n', '<leader>gc', builtin.git_commits,          'Git commits')
    end,
  },
}
