return {
  -- LSP Configuration & Plugins
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "basedpyright", "ruff", "kotlin_lsp", "lua_ls" },
      })

      -- 1. Set global capabilities for ALL servers
      -- This replaces passing capabilities to every single setup call.
      vim.lsp.config('*', {
        capabilities = require('blink.cmp').get_lsp_capabilities()
      })

      -- 2. Define Basedpyright configuration
      vim.lsp.config('basedpyright', {
        settings = {
          basedpyright = {
            analysis = {
              typeCheckingMode = "basic",
              autoImportCompletions = true,
              diagnosticMode = "openFilesOnly",
            },
          },
        },
      })

      -- 3. Define Ruff configuration (empty table uses lspconfig defaults)
      vim.lsp.config('ruff', {})
      vim.lsp.config("kotlin_lsp", {
        cmd = vim.lsp.rpc.connect('127.0.0.1', tonumber(9999)),
        single_file_support = false,
      })

      vim.lsp.config('lua_ls', {
        settings = {
          Lua = {
            diagnostics = {
              globals = { 'vim' },
            },
          },
        },
      })

      -- 4. Enable the servers
      vim.lsp.enable('basedpyright')
      vim.lsp.enable('ruff')
      vim.lsp.enable("kotlin_lsp")
      vim.lsp.enable('lua_ls')
      -- vim.lsp.enable('kotlin-lsp')

      -- 5. Handle "on_attach" logic globally via Autocommands
      -- This is the modern way to modify client capabilities (like Ruff's hover)
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          
          -- Disable hover in Ruff to let Basedpyright handle it
          if client and client.name == 'ruff' then
            client.server_capabilities.hoverProvider = false
          end
        end,
      })
    end,
  },
  -- {
  -- "AlexandrosAlexiou/kotlin.nvim",
  -- dependencies = { "neovim/nvim-lspconfig" },
  --   ft = { "kotlin" },
  --   config = function()
  --       require("kotlin").setup {
  --         -- jre_path = os.getenv("JAVA_HOME"),
  --         -- jdk_for_symbol_resolution = '/usr/lib/jvm/java-21-openjdk',
  --       }
  --   end,
  -- },

  -- Completion Engine (Blink.cmp)
  {
    'saghen/blink.cmp',
    version = '*',
    opts = {
      keymap = { 
          preset = 'none',
          ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
            ['<C-e>'] = { 'hide', 'fallback' },
            ['<CR>'] = { 'accept', 'fallback' },

            ['<Tab>'] = { 'snippet_forward', 'fallback' },
            ['<S-Tab>'] = { 'snippet_backward', 'fallback' },

            ['<Up>'] = { 'select_prev', 'fallback' },
            ['<Down>'] = { 'select_next', 'fallback' },
            ['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
            ['<C-n>'] = { 'select_next', 'fallback_to_mappings' },

            ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
            ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

            ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
      },
      appearance = { use_nvim_cmp_as_default = true, nerd_font_variant = 'mono' },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
      completion = {
        menu = {
            auto_show = true,
        },
        ghost_text = {
            enabled = true,
        },
        list = {
          selection = {
            preselect = false,
            -- auto_insert = true,
          },
        },
      },
    },
  },

  -- Auto-formatting (Conform.nvim)
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        -- Ruff is lightning fast for formatting and import sorting
        python = { "ruff_organize_imports", "ruff_format" },
        kotlin = { "ktlint" },
      },
      format_on_save = { timeout_ms = 500, lsp_fallback = true },
    },
  },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    config = function()
        require("tiny-inline-diagnostic").setup()
        vim.diagnostic.config({ virtual_text = false }) -- Disable Neovim's default virtual text diagnostics
    end,
},
  {
    'nvimdev/lspsaga.nvim',
    config = function()
        require('lspsaga').setup({})
    end,
    dependencies = {
        -- 'nvim-treesitter/nvim-treesitter', -- optional
        'nvim-tree/nvim-web-devicons',     -- optional
    }
}
}
