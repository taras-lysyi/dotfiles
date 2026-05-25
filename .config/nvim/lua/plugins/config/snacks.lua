-- snacks.nvim — folke's swiss-army UX plugin
-- https://github.com/folke/snacks.nvim
require("snacks").setup({
  -- Big files: disable expensive features for large buffers
  bigfile = { enabled = true },
  -- Faster file loading on startup
  quickfile = { enabled = true },

  -- Dashboard (replaces alpha-nvim which was disabled anyway)
  dashboard = {
    enabled = true,
    preset = {
      header = [[
   ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
   ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
   ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
   ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
   ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
   ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
      ]],
      keys = {
        { icon = " ", key = "f", desc = "Find File", action = ":FzfLua files" },
        { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
        { icon = " ", key = "g", desc = "Find Text", action = ":FzfLua live_grep" },
        { icon = " ", key = "r", desc = "Recent Files", action = ":FzfLua oldfiles" },
        { icon = " ", key = "c", desc = "Config", action = ":e $MYVIMRC" },
        { icon = " ", key = "L", desc = "Lazy", action = ":Lazy" },
        { icon = " ", key = "q", desc = "Quit", action = ":qa" },
      },
    },
    sections = {
      { section = "header" },
      { section = "keys", gap = 1, padding = 1 },
      { section = "startup" },
    },
  },

  -- Indent guides disabled per preference
  indent = { enabled = false },

  -- Notifier replaces vim.notify
  notifier = {
    enabled = true,
    timeout = 3000,
    style = "compact", -- "compact" | "fancy" | "minimal"
    top_down = false,
  },

  -- vim.ui.input replacement (transparent — no keymap changes)
  input = { enabled = true },

  -- Smooth scroll disabled per preference
  scroll = { enabled = false },

  -- Show statuscolumn improvements (folds + signs)
  statuscolumn = { enabled = false }, -- disable: you have custom signcolumn behavior

  -- Word-under-cursor highlight (snacks does this lighter than treesitter)
  words = { enabled = false },

  -- Bottom terminal
  terminal = {
    enabled = true,
    win = {
      style = "terminal",
      position = "bottom",
      height = 0.35,
      border = "none",
    },
  },
})

-- Snacks terminal keymaps (replaces toggleterm)
vim.keymap.set({ "n", "t", "i" }, "<C-t>", function()
  Snacks.terminal.toggle()
end, { desc = "Toggle bottom terminal" })

-- Toggle ALL terminals (show all if any hidden, hide all if all shown)
vim.keymap.set({ "n", "t", "i" }, "<C-a>", function()
  local terms = Snacks.terminal.list()
  if #terms == 0 then
    Snacks.terminal.toggle()
    return
  end
  local any_hidden = false
  for _, t in ipairs(terms) do
    if not t:win_valid() then
      any_hidden = true
      break
    end
  end
  for _, t in ipairs(terms) do
    if any_hidden then
      t:show()
    else
      t:hide()
    end
  end
end, { desc = "Show/hide ALL terminals" })

vim.keymap.set("n", "<leader>tg", function()
  Snacks.terminal.toggle("lazygit", { cwd = vim.fn.getcwd(), win = { position = "float", border = "rounded", width = 0.9, height = 0.9 } })
end, { desc = "Lazygit" })

vim.keymap.set("n", "<leader>tp", function()
  Snacks.terminal.toggle("pi", { cwd = vim.fn.getcwd(), win = { position = "float", border = "rounded", width = 0.9, height = 0.9 } })
end, { desc = "Pi agent" })
