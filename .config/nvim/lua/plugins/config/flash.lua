-- flash.nvim — modern motion plugin replacing hop.nvim
-- https://github.com/folke/flash.nvim
require("flash").setup({
  labels = "asdfghjklqwertyuiopzxcvbnm",
  search = {
    multi_window = true,
    forward = true,
    wrap = true,
    -- Use fuzzy-like char-by-char matching similar to HopChar2
    mode = "exact",
    incremental = false,
  },
  jump = {
    autojump = false,
  },
  label = {
    uppercase = true,
    rainbow = {
      enabled = true,
      shade = 5,
    },
  },
  modes = {
    -- Press s in normal/visual to trigger flash
    char = {
      enabled = true,
      jump_labels = true,
      multi_line = true,
    },
    -- Treesitter mode: select syntax nodes with labels
    treesitter = {
      labels = "abcdefghijklmnopqrstuvwxyz",
    },
  },
})
