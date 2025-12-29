return {
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function()
        -- This plugin only works if all requirements are installed (see https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#requirements)

        require'nvim-treesitter'.install {
          'markdown',
          'lua',
          'hcl',
          'python',
          'json',
          'yaml',
          'toml',
          'bash',
          'vim',
          'typescript'
        }

        vim.api.nvim_create_autocmd("FileType", {
          callback = function(event)
            local filetype = event.match

            -- Enable parsing and syntax highlighting based on treesitter
            if not pcall(vim.treesitter.start) then
              return
            end

            -- Enable folding based on treesitter
            if vim.treesitter.query.get(filetype, "folds") then
              vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
              vim.opt_local.foldmethod = "expr"
            end

            -- Enable indentation based on treesitter
            if vim.treesitter.query.get(filetype, "indents") then
              vim.opt_local.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end
          end,
        })
      end,
    },
}