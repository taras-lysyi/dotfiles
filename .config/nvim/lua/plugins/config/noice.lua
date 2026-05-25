-- noice.nvim — modern cmdline, messages, popupmenu, LSP progress
-- https://github.com/folke/noice.nvim
require("noice").setup({
  cmdline = {
    enabled = true,
    view = "cmdline", -- classic bottom cmdline
    format = {
      cmdline = { icon = " " },
      search_down = { icon = " " },
      search_up = { icon = " " },
      filter = { icon = "$" },
      lua = { icon = " " },
      help = { icon = " " },
    },
  },
  messages = {
    enabled = true,
    view = "notify",
    view_error = "notify",
    view_warn = "notify",
    view_history = "messages",
  },
  popupmenu = {
    enabled = true,
    backend = "nui",
  },
  lsp = {
    progress = { enabled = true },
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
    hover = { enabled = true },
    signature = { enabled = true },
    message = { enabled = true },
    documentation = {
      view = "hover",
      opts = {
        lang = "markdown",
        replace = true,
        render = "plain",
        format = { "{message}" },
        win_options = { concealcursor = "n", conceallevel = 3 },
      },
    },
  },
  presets = {
    bottom_search = true,        -- search stays at bottom
    command_palette = false,     -- no floating cmdline+menu
    long_message_to_split = true,
    inc_rename = false,
    lsp_doc_border = true,
  },
  routes = {
    -- Suppress "written" messages
    {
      filter = {
        event = "msg_show",
        kind = "",
        find = "written",
      },
      opts = { skip = true },
    },
  },
})
