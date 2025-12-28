-- Disabling swap and backup files of neovim
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

-- Chdir to the file's directory when opening a file
vim.opt.autochdir = true
vim.opt.path:append("**")

-- UI / behavior
vim.opt.number = true
vim.opt.scrolloff = 3
vim.opt.scroll = 10
vim.opt.visualbell = false
vim.opt.listchars = {
  tab = "▸ ",
  eol = "¬",
  extends = "❯",
  precedes = "❮",
}
vim.opt.lazyredraw = true
vim.opt.background = "dark"

-- Various settings
vim.opt.fileformats = { "unix", "dos" }
vim.opt.clipboard = "unnamedplus"
vim.opt.modeline = false -- disabled for security reasons
vim.opt.undofile = true

-- line reak
vim.opt.breakindent = true -- wrapped lines will be visually indented
vim.opt.linebreak = true -- do not split words when wrapping lines
vim.opt.wildmode = "longest:full,full" -- first tab complete only longest common string, second tab complete to first element in list
vim.opt.wildignorecase = true -- ignore case when completing file names and directories

-- Searching
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Tabs to spaces and identation
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.copyindent = true -- copy the previous indentation on autoindenting

-- Folding
vim.opt.foldmethod = "syntax"
vim.opt.foldlevel = 99

-- filetype
vim.g.markdown_fenced_languages = {
  "xml",
  "html",
  "sql",
  "python",
  "javascript",
  "typescript",
  "bash",
  "sh",
  "yaml",
  "json",
}
vim.g.netrw_browsex_viewer = "xdg-open"

-- Keymaps
-- use arrow keys to move between windows
vim.keymap.set("n", "<Left>", "<C-w>h", { noremap = true })
vim.keymap.set("n", "<Down>", "<C-w>j", { noremap = true })
vim.keymap.set("n", "<Up>", "<C-w>k", { noremap = true })
vim.keymap.set("n", "<Right>", "<C-w>l", { noremap = true })

-- because of soft wrap
vim.keymap.set("n", "j", "gj", { noremap = true })
vim.keymap.set("n", "k", "gk", { noremap = true })
vim.keymap.set("v", "j", "gj", { noremap = true })
vim.keymap.set("v", "k", "gk", { noremap = true })

-- Load plugins
require("config.lazy")
