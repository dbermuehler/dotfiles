return {
  -- Mason: manages external tools (LSPs, formatters, linters)
  {
    "williamboman/mason.nvim",
    opts = {},
  },

  -- Provides pre-configured LSP server defaults for vim.lsp.config
  { "neovim/nvim-lspconfig" },

  -- Ensures Mason installs the specified LSP servers
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "mason.nvim", "nvim-lspconfig" },
    opts = {
      ensure_installed = {
        "ty",
        "ruff",
        "lua_ls",
        "bashls",
        "terraformls",
        "ts_ls",
        "jsonls",
        "yamlls",
        "taplo",
      },
    },
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)

      vim.diagnostic.config({ virtual_text = true })

      -- gd for go-to-definition (CTRL-] doesn't work well on macOS)
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = args.buf })
        end,
      })

      -- Override lua_ls settings for Neovim development (merge with defaults)
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            workspace = {
              checkThirdParty = false,
              library = vim.api.nvim_get_runtime_file("", true),
            },
            diagnostics = {
              globals = { "vim" },
            },
            telemetry = { enable = false },
          },
        },
      })

      -- Enable all servers (configs are pre-populated by nvim-lspconfig)
      vim.lsp.enable({
        "ty",
        "ruff",
        "lua_ls",
        "bashls",
        "terraformls",
        "ts_ls",
        "jsonls",
        "yamlls",
        "taplo",
      })
    end,
  },
}
