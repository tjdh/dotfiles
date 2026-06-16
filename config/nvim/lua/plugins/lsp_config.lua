vim.o.winborder = "rounded"

local float_table = { float = { border = "rounded" } }
-- clangd installed via apt (mason binary download fails on WSL2)
local mason_servers = { "pyright", "bashls", "lua_ls" }
local lsp_servers   = { "pyright", "clangd", "bashls", "lua_ls" }

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "folke/lazydev.nvim",      opts = {}, ft = "lua" },
      { "williamboman/mason.nvim", opts = {} },
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities(
        vim.lsp.protocol.make_client_capabilities()
      )

      vim.lsp.config('*', {
        capabilities = capabilities,
        on_attach = function(client, _)
          client.server_capabilities.semanticTokensProvider = nil
        end,
      })

      require("mason-lspconfig").setup({
        ensure_installed = mason_servers,
        automatic_enable = true,
      })

      vim.lsp.enable(lsp_servers)

      local map = require('confs.utils').map
      vim.diagnostic.config({ signs = false, underline = true })
      map('n', '[d', function() vim.diagnostic.goto_prev(float_table) end, 'Prev diagnostic')
      map('n', ']d', function() vim.diagnostic.goto_next(float_table) end, 'Next diagnostic')
      map('n', '<leader>dl', vim.diagnostic.setloclist, 'Diagnostics in loclist')

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          local opts = { buffer = ev.buf }
          map('n', 'gd',          vim.lsp.buf.definition,    'Goto definition',           opts)
          map('n', 'gr',          vim.lsp.buf.references,    'LSP references',             opts)
          map('n', 'K',           vim.lsp.buf.hover,         'Hover',                      opts)
          map('n', '<leader>sr',  vim.lsp.buf.rename,        'Rename symbol',              opts)
          map({'n','v'}, 'gf',    vim.lsp.buf.format,        'LSP format',                 opts)
          map({'n','v'}, '<leader>ca', vim.lsp.buf.code_action, 'Code action',             opts)
          map('n', '<leader>wa',  vim.lsp.buf.add_workspace_folder,    'Add workspace folder',    opts)
          map('n', '<leader>wr',  vim.lsp.buf.remove_workspace_folder, 'Remove workspace folder', opts)
          map('n', '<leader>wl',  function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, 'List workspace folders', opts)
          map('n', '<leader>ls',  '<cmd>LspStop<CR>',    'Stop LSP',    opts)
          map('n', '<leader>lr',  '<cmd>LspRestart<CR>', 'Restart LSP', opts)
        end,
      })
    end,
  },
}
