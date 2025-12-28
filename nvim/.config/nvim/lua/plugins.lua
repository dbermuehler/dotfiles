return {
    -- UI Plugins
    "inside/vim-search-pulse",
    "mhinz/vim-signify",
    {
      "kristijanhusak/vim-hybrid-material",
      lazy = false,
      priority = 1000,
      init = function()
        vim.g.enable_italic_font = 1
        vim.g.enable_bold_font = 1
      end,
      config = function()
        vim.cmd.colorscheme("hybrid_material")
      end,
    },
    {
      "vim-airline/vim-airline",
      dependencies = { "vim-airline/vim-airline-themes" },
      init = function()
        vim.g["airline#extensions#tabline#enabled"] = 0
        vim.g["airline#extensions#tabline#show_buffers"] = 0
        vim.g.airline_theme = "hybrid"
        vim.g.airline_powerline_fonts = 1
      end,
    },

    -- Editing Plugins
    "github/copilot.vim",
    'ntpeters/vim-better-whitespace',
    { "numToStr/Comment.nvim", opts = {} },
    { 'windwp/nvim-autopairs', event = "InsertEnter", opts = {} },
    { 'junegunn/fzf.vim', dependencies = { 'junegunn/fzf' } },
}
