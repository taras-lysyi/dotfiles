local options = {
  backup = false,                         -- creates a backup file
  clipboard = "unnamedplus",              -- allows neovim to access the system clipboard (cross-platform)
  cmdheight = 0,
  completeopt = { "menuone", "noselect" }, -- mostly just for cmp
  conceallevel = 0,                       -- so that `` is visible in markdown files
  fileencoding = "utf-8",                 -- the encoding written to a file
  hlsearch = true,                        -- highlight all matches on previous search pattern
  ignorecase = true,                      -- ignore case in search patterns
  mouse = "a",                            -- allow the mouse to be used in neovim
  pumheight = 10,                         -- pop up menu height
  showmode = false,                       -- we don't need to see things like -- INSERT -- anymore
  ruler = false,                          -- hide cursor position from command/status line
  showcmd = false,                        -- hide partial command display
  showtabline = 2,                        -- always show tabs
  smartcase = true,                       -- smart case
  smartindent = true,                     -- make indenting smarter again
  splitbelow = true,                      -- force all horizontal splits to go below current window
  splitright = true,                      -- force all vertical splits to go to the right of current window
  swapfile = false,                       -- creates a swapfile
  termguicolors = true,                   -- set term gui colors (most terminals support this)
  timeoutlen = 1000,                      -- time to wait for a mapped sequence to complete (in milliseconds)
  undofile = true,                        -- enable persistent undo
  updatetime = 300,                       -- faster completion (4000ms default)
  writebackup = false,                    -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
  expandtab = true,                       -- convert tabs to spaces
  shiftwidth = 2,                         -- the number of spaces inserted for each indentation
  tabstop = 2,                            -- insert 2 spaces for a tab
  cursorline = true,                      -- highlight the current line
  scrolloff = 999,                        -- keep cursor centered vertically in the window
  number = true,                          -- set numbered lines
  relativenumber = false,                 -- set relative numbered lines
  numberwidth = 2,                        -- set number column width to 2 {default 4}
  signcolumn = "yes",                     -- always show the sign column, otherwise it would shift the text each time
  wrap = true,                            -- display lines as one long line
  linebreak = true,
  breakindent = true,
  guicursor = "i:block",
  -- Font settings for GUI Neovim (Neovide, etc.)
  guifont = "SF Mono:h13",
  laststatus = 0,
  -- Better rendering
  smoothscroll = true,
  foldenable = true,
  splitkeep = "screen",
  foldlevel = 100,
  foldmethod = "expr",                    -- use treesitter-based folding
  foldexpr = "v:lua.vim.treesitter.foldexpr()", -- treesitter fold expression
  foldcolumn = "0",
  foldlevelstart = 99,
  fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]],
  autoread = true,
}

vim.opt.shortmess:append("c")

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.cmd([[
  set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz
  set langmap+=ЖжЭэХхЪъ;\:\;\"\'{[}]
]])
