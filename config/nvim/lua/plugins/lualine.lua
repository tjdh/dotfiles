return {
  {
    'nvim-lualine/lualine.nvim',
    opts = {
      options = {
        icons_enabled = true,
        theme = 'catppuccin',
        component_separators = '|',
        section_separators = '',
        disabled_filetypes = {},
        always_divide_middle = true,
      },
      sections = {
        lualine_a = {'mode'},
        lualine_b = {
          'branch',
          { 'diff', colored = false },
          'diagnostics',
        },
        lualine_c = {
          { 'filename', symbols = { readonly = '[RO]' } }
        },
        lualine_x = {'encoding', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'},
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          { 'filename', symbols = { readonly = '[RO]' } }
        },
        lualine_x = {'filetype'},
        lualine_y = {'progress'},
        lualine_z = {},
      },
      tabline = {},
      extensions = {'nvim-tree', 'quickfix'},
    },
  },
}
