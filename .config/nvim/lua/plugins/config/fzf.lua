local status_ok, fzf = pcall(require, "fzf-lua")
if not status_ok then
  return
end

fzf.setup({
  "default-title",
  defaults = {
    -- Use file icons, disable git icons to avoid git root limitation
    global_file_icons = true,
    global_git_icons = false,
  },
  winopts = {
    height = 0.85,
    width = 0.80,
    border = "rounded",
    preview = {
      border = "rounded",
      layout = "flex",
      flip_columns = 120,
    },
    -- Add keybinds for fzf window
    on_create = function()
      -- Map Cmd+j/k for macOS navigation (in terminal mode)
      vim.keymap.set("t", "<D-j>", "<Down>", { silent = true, buffer = true })
      vim.keymap.set("t", "<D-k>", "<Up>", { silent = true, buffer = true })
      -- Also map Ctrl+j/k as alternative
      vim.keymap.set("t", "<C-j>", "<Down>", { silent = true, buffer = true })
      vim.keymap.set("t", "<C-k>", "<Up>", { silent = true, buffer = true })
    end,
  },
  previewers = {
    builtin = {
      syntax = true,              -- enable syntax highlighting
      syntax_limit_l = 500,       -- limit to 500 lines for performance
      syntax_limit_b = 512*1024,  -- 512KB limit for performance
      treesitter = {
        enabled = true,           -- enable treesitter highlighting
        disabled = {},            -- don't disable any filetypes
      },
    },
  },
  fzf_opts = {
    ["--layout"] = "reverse-list",
  },
  grep = {
    rg_opts = table.concat({
      "--column",
      "--line-number", 
      "--no-heading",
      "--color=always",
      "--smart-case",
      "--max-columns=4096",
      "--hidden",
      -- Exclude common directories for better performance
      "--glob=!.git/*",
      "--glob=!node_modules/*",
      "--glob=!vendor/*",
      "--glob=!.next/*",
      "--glob=!dist/*",
      "--glob=!build/*",
    }, " "),
    git_icons = false,
  },
  files = {
    git_icons = false,
    fzf_opts = {
      ["--info"] = "inline-right",
      -- Case-insensitive fuzzy matching
      ["-i"] = "",
      -- Use v2 algorithm for better fuzzy matching
      ["--algo"] = "v2",
    },
  },
})

-- Keymaps (migrated from Telescope)
local opts = { noremap = true, silent = true }

-- ,f - Find files (fuzzy)
vim.keymap.set("n", "<leader>f", function()
  fzf.files({
    cwd = vim.fn.getcwd(),  -- Explicitly use current working directory
    cmd = "rg --files --hidden --no-ignore",
  })
end, { desc = "Find files (fuzzy)" })

-- ,g - Grep all project lines with FUZZY search (like fzf.vim's :Rg)
-- Using live_grep for better performance (opens immediately, no indexing delay)
vim.keymap.set("n", "<leader>g", function()
  fzf.live_grep({
    resume = false,
  })
end, { desc = "Grep project (live grep)" })

-- ,G - Grep only .go files (Go-specific search)
vim.keymap.set("n", "<leader>G", function()
  fzf.live_grep({
    rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --glob=*.go",
  })
end, { desc = "Grep Go files only" })

-- ,r - Recent files (oldfiles)
vim.keymap.set("n", "<leader>r", "<cmd>FzfLua history<cr>", vim.tbl_extend("force", opts, { desc = "Recent files" }))

-- ,v - Buffers
vim.keymap.set("n", "<leader>v", "<cmd>FzfLua buffers<cr>", vim.tbl_extend("force", opts, { desc = "Buffers" }))

-- ,t - Git status
vim.keymap.set("n", "<leader>t", "<cmd>FzfLua git_status<cr>", vim.tbl_extend("force", opts, { desc = "Git status" }))

-- ,dd / ,dw - Diagnostics
vim.keymap.set("n", "<leader>dd", function()
  fzf.diagnostics_document()
end, vim.tbl_extend("force", opts, { desc = "Document diagnostics" }))

vim.keymap.set("n", "<leader>dw", function()
  fzf.diagnostics_workspace()
end, vim.tbl_extend("force", opts, { desc = "Workspace diagnostics" }))

-- ,ss / ,sw - Symbols
vim.keymap.set("n", "<leader>ss", function()
  fzf.lsp_document_symbols()
end, vim.tbl_extend("force", opts, { desc = "Document symbols" }))

vim.keymap.set("n", "<leader>sw", function()
  fzf.lsp_workspace_symbols()
end, vim.tbl_extend("force", opts, { desc = "Workspace symbols" }))

-- ,p - Projects (using project.nvim with custom fzf picker)
vim.keymap.set("n", "<leader>p", function()
  local project_nvim = require("project_nvim.project")
  local history = require("project_nvim.utils.history")
  local results = history.get_recent_projects()
  
  fzf.fzf_exec(results, {
    prompt = "Projects> ",
    actions = {
      ["default"] = function(selected)
        if selected and selected[1] then
          -- Change to the new project directory
          vim.cmd("cd " .. selected[1])
          -- Close all buffers to avoid confusion
          vim.cmd("bufdo bwipeout")
          -- Open nvim-tree in the new directory
          vim.cmd("NvimTreeOpen")
          -- Explicitly set fzf-lua's cwd for future searches
          vim.cmd("cd " .. selected[1])
        end
      end
    }
  })
end, vim.tbl_extend("force", opts, { desc = "Projects" }))

-- gr - LSP references
vim.keymap.set("n", "gr", function()
  fzf.lsp_references()
end, vim.tbl_extend("force", opts, { desc = "LSP references" }))

