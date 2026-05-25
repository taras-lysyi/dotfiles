vim.cmd([["
  augroup remember_folds
    autocmd!
    autocmd BufWinLeave *.* mkview
    autocmd BufWinEnter *.* silent! loadview
  augroup END

  augroup cursorline
    autocmd!
    autocmd WinEnter,BufEnter * setlocal cursorline
    autocmd WinLeave,BufLeave * setlocal nocursorline
  augroup END
augroup fzf_commands
  autocmd!
  autocmd FileType fzf tnoremap <silent> <buffer> <c-j> <down>
  autocmd FileType fzf tnoremap <silent> <buffer> <c-k> <up>
augroup end

""]])

local create_autocmds = require("utils").create_autocmds

-- Clean stale shada tmp files left by previous crashed sessions.
-- Stale tmps make :q slow because nvim retries+merges them on write.
vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("ShadaCleanup", { clear = true }),
  desc = "Remove stale shada tmp files",
  callback = function()
    vim.fn.system("rm -f ~/.local/state/nvim/shada/main.shada.tmp.*")
  end,
})

-------------------------------------------------------------------------------
------ AUTOCOMMANDS
-------------------------------------------------------------------------------

local BufCheck = vim.api.nvim_create_augroup("bufcheck", { clear = true })
local buffer_dict = {
  BufEnter = {
    {
      group = BufCheck,
      pattern = "*",
      desc = "Update a buffer's contents on focus if it has changed outside of Vim.",
      command = "checktime",
    },
  },
  FocusGained = {
    {
      group = BufCheck,
      pattern = "*",
      desc = "Update a buffer's contents on focus if it has changed outside of Vim.",
      command = "checktime",
    },
    {
      group = BufCheck,
      pattern = "*",
      desc = "Refresh NvimTree on FocusGained.",
      command = "NvimTreeRefresh",
    },
  },
  TermClose = {
    {
      group = BufCheck,
      pattern = "*",
      desc = "Refresh NvimTree on TermClose.",
      command = "NvimTreeRefresh",
    },
  },
  FileType = {
    {
      group = BufCheck,
      pattern = { "gitcommit", "gitrebase" },
      command = "startinsert | 1",
    },
  },
}

--
local Filetype = vim.api.nvim_create_augroup("filetype", { clear = true })

local filetype_dict = {
  FileType = {
    -- {
    {
      group = Filetype,
      pattern = { "gitcommit", "gitrebase" },
      command = "startinsert | 1",
    },
  },
}

create_autocmds(buffer_dict)
create_autocmds(filetype_dict)

-------------------------------------------------------------------------------
------ STRIP TRAILING SPACES FROM YANKED TEXT
-------------------------------------------------------------------------------
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Strip trailing whitespace from yanked text in clipboard",
  callback = function()
    if vim.v.event.operator ~= "y" then
      return
    end
    local reg = vim.v.event.regname
    -- Handle unnamedplus: empty regname means default register, which syncs to +
    if reg ~= "" and reg ~= "+" then
      return
    end
    local content = vim.fn.getreg("+")
    local cleaned = content:gsub("[ \t]+\n", "\n"):gsub("[ \t]+$", "")
    if cleaned ~= content then
      vim.fn.setreg("+", cleaned)
    end
  end,
})

-------------------------------------------------------------------------------
------ PLUGINS
-------------------------------------------------------------------------------

local alpha_disable_folding = vim.api.nvim_create_augroup("AlphaDisableFolding", { clear = true })

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = alpha_disable_folding,
  pattern = "alpha",
  desc = "Disable folding on Alpha buffer.",
  command = "setlocal nofoldenable",
})

-------------------------------------------------------------------------------
------ CHANGE TERMINAL TITLE TO GIT BRANCH
-------------------------------------------------------------------------------
local terminal_title = vim.api.nvim_create_augroup("TerminalTitle", { clear = true })

-- Function to restore terminal title to git branch name
local function restore_terminal_title()
  -- Get git branch
  local handle = io.popen("git branch --show-current 2>/dev/null")
  local branch = handle:read("*a"):gsub("\n", "")
  handle:close()
  
  if branch ~= "" then
    -- Write escape sequence directly to terminal
    io.write(string.format("\027]0;%s\007", branch))
    io.flush()
  end
end

-- Restore title when entering neovim, leaving, or gaining focus
vim.api.nvim_create_autocmd({ "VimEnter", "VimLeave", "FocusLost", "FocusGained" }, {
  group = terminal_title,
  desc = "Restore terminal title to git branch",
  callback = restore_terminal_title,
})
