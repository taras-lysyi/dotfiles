-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  -- Utils
  "moll/vim-bbye",
  "folke/which-key.nvim",
  {
    "segeljakt/vim-silicon",
    cmd = "Silicon",
    config = function()
      vim.cmd([[
        let g:silicon={
          \   'theme':              'GitHub',
          \   'font':               'JetBrainsMono Nerd Font',
          \   'to-clipboard':       v:true,
        \ }]])
    end,
  },

  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("plugins.config.nvim-tree")
    end,
  },
  {
    "ibhagwan/fzf-lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { "<leader>f", desc = "Find files (fuzzy)" },
      { "<leader>g", desc = "Grep project" },
      { "<leader>r", desc = "Recent files" },
      { "<leader>v", desc = "Buffers" },
      { "<leader>t", desc = "Git status" },
      { "<leader>p", desc = "Projects" },
      { "<leader>dd", desc = "Document diagnostics" },
      { "<leader>dw", desc = "Workspace diagnostics" },
      { "<leader>ss", desc = "Document symbols" },
      { "<leader>sw", desc = "Workspace symbols" },
      { "gr", desc = "LSP references" },
    },
    cmd = { "FzfLua" },
    config = function()
      require("plugins.config.fzf")
    end,
  },
  {
    "folke/todo-comments.nvim",
    config = function()
      require("plugins.config.todo-comments")
    end,
  },

  -- Editing
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("plugins.config.autopairs")
    end,
  },
  "tpope/vim-repeat",
  "tpope/vim-abolish",
  {
    "kylechui/nvim-surround",
    config = function()
      require("nvim-surround").setup({})
    end,
  },

  -- Motion (flash.nvim replaces hop.nvim)
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<space>s",
        mode = { "n", "x", "o" },
        function() require("flash").jump() end,
        desc = "Flash jump",
      },
      {
        "<space>S",
        mode = { "n", "x", "o" },
        function() require("flash").treesitter() end,
        desc = "Flash treesitter",
      },
      {
        "r",
        mode = "o",
        function() require("flash").remote() end,
        desc = "Remote flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function() require("flash").treesitter_search() end,
        desc = "Treesitter search",
      },
    },
    config = function()
      require("plugins.config.flash")
    end,
  },

  -- UI
  -- snacks.nvim — folke's UX swiss-army (dashboard, indent, notifier, input, scroll, bigfile)
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    config = function()
      require("plugins.config.snacks")
    end,
  },
  -- noice.nvim — modern cmdline + LSP UI
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "folke/snacks.nvim",
    },
    config = function()
      require("plugins.config.noice")
    end,
  },
  {
    "stevearc/dressing.nvim",
    enabled = false, -- replaced by snacks.input
    config = function()
      require("plugins.config.lsp.dressing")
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    enabled = false,
  },
  {
    -- Using maintained fork with updated APIs
    "coffebar/project.nvim",
    config = function()
      require("plugins.config.project")
    end,
  },
  {
    "goolord/alpha-nvim",
    enabled = false,
  },
  "kevinhwang91/nvim-bqf",
  -- toggleterm replaced by snacks.terminal
  { "akinsho/toggleterm.nvim", enabled = false },
  {
    "akinsho/bufferline.nvim",
    config = function()
      require("plugins.config.bufferline")
    end,
  },
  {
    "rmagatti/goto-preview",
    keys = {
      { "gpd", desc = "Goto preview definition" },
      { "gpt", desc = "Goto preview type definition" },
      { "gpi", desc = "Goto preview implementation" },
      { "gpr", desc = "Goto preview references" },
      { "gP", desc = "Close all preview windows" },
    },
    config = function()
      require("goto-preview").setup({
        default_mappings = true,
      })
    end,
  },

  -- Code reading / Colorschemes
  {
    "catppuccin/nvim",
    name = "catppuccin",
  },
  "projekt0n/github-nvim-theme",
  {
    "brenoprata10/nvim-highlight-colors",
    event = "BufReadPre",
    config = function()
      require("nvim-highlight-colors").setup({
        render = "background", -- 'background', 'foreground', 'virtual'
        enable_named_colors = true,
        enable_tailwind = true,
      })
    end,
  },
  "folke/tokyonight.nvim",
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main", -- Use the main branch (master is deprecated)
    lazy = false,
    priority = 1000, -- Load before LSP to ensure highlighting autocmd is registered first
    build = ":TSUpdate",
    config = function()
      require("plugins.config.treesitter")
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "InsertEnter",
    opts = {
      enable_close = true,
      enable_rename = true,
      enable_close_on_slash = false,
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    lazy = false,
    opts = {
      enable = true,
      max_lines = 2,
      trim_scope = "outer",
    },
  },
  {
    "m-demare/hlargs.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    lazy = false, -- Load immediately after treesitter
    config = function()
      require("hlargs").setup()
    end,
  },

  -- Formatting
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    config = function()
      require("plugins.config.conform")
    end,
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    dependencies = { "nvim-treesitter/nvim-treesitter" }, -- Ensure treesitter loads first
    config = function()
      require("plugins.config.lsp.init")
    end,
  },
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "tamago324/nlsp-settings.nvim",
  {
    "hedyhli/outline.nvim",
    keys = {
      { "<space><space>", ":Outline<CR>", desc = "Toggle symbols outline" },
    },
    cmd = { "Outline", "OutlineOpen" },
    config = function()
      require("plugins.config.lsp.symbols-outline")
    end,
  },

  -- LSP UI
  "folke/trouble.nvim",
  "MunifTanjim/nui.nvim",
  { "lukas-reineke/indent-blankline.nvim", enabled = false }, -- replaced by snacks.indent
  {
    "SmiteshP/nvim-navic",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
  },

  -- Completion
  {
    "hrsh7th/nvim-cmp",
    config = function()
      require("plugins.config.cmp")
    end,
  },
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  "saadparwaiz1/cmp_luasnip",
  "hrsh7th/cmp-nvim-lsp",
  "L3MON4D3/LuaSnip",
  "rafamadriz/friendly-snippets",
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    cmd = "Copilot",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          keymap = {
            accept = "<Tab>",
            accept_word = false,
            accept_line = false,
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
        panel = {
          enabled = true,
          auto_refresh = false,
          keymap = {
            jump_prev = "[[",
            jump_next = "]]",
            accept = "<CR>",
            refresh = "gr",
            open = "<M-CR>",
          },
        },
        filetypes = {
          ["*"] = true,
        },
        -- Ensure copilot LSP server is enabled for sidekick.nvim
        server_opts_overrides = {
          trace = "verbose",
          settings = {
            advanced = {
              listCount = 10,
              inlineSuggestCount = 3,
            },
          },
        },
      })
    end,
  },
  {
    "folke/sidekick.nvim",
    dependencies = {
      "zbirenbaum/copilot.lua", -- Copilot.lua manages the LSP server
    },
    init = function()
      -- Enable Copilot LSP for sidekick
      vim.lsp.enable("copilot_ls")
    end,
    opts = {
      nes = {
        enabled = true,
        debounce = 200,
      },
      cli = {
        watch = true,
        mux = {
          backend = "tmux",
          enabled = true, -- Enable for persistent AI sessions
          create = "terminal", -- Create in Neovim terminal (not tmux window/split)
        },
        win = {
          layout = "right",
        },
        tools = {
          cursor = { cmd = { "cursor", "agent", "--force", "--approve-mcps" }, url = "https://cursor.com/cli" },
        },
      },
    },
    keys = {
      {
        "<Tab>",
        function()
          -- if there is a next edit, jump to it, otherwise apply it if any
          if not require("sidekick").nes_jump_or_apply() then
            return "<Tab>" -- fallback to normal tab
          end
        end,
        mode = "n",
        expr = true,
        desc = "Goto/Apply Next Edit Suggestion",
      },
      {
        "<c-.>",
        function() require("sidekick.cli").toggle() end,
        desc = "Sidekick Toggle",
        mode = { "n", "t", "i", "x" },
      },
      {
        "<leader>aa",
        function() require("sidekick.cli").toggle({ name = "cursor", focus = true }) end,
        desc = "Sidekick Toggle Cursor Agent",
      },
      {
        "<leader>as",
        function() require("sidekick.cli").select() end,
        desc = "Select CLI",
      },
      {
        "<leader>ad",
        function() require("sidekick.cli").close() end,
        desc = "Detach a CLI Session",
      },
      {
        "<leader>at",
        function() require("sidekick.cli").send({ msg = "{this}" }) end,
        mode = { "x", "n" },
        desc = "Send This",
      },
      {
        "<leader>af",
        function() require("sidekick.cli").send({ msg = "{file}" }) end,
        desc = "Send File",
      },
      {
        "<leader>av",
        function() require("sidekick.cli").send({ msg = "{selection}" }) end,
        mode = { "x" },
        desc = "Send Visual Selection",
      },
      {
        "<leader>ap",
        function() require("sidekick.cli").prompt() end,
        mode = { "n", "x" },
        desc = "Sidekick Select Prompt",
      },
      {
        "<leader>ac",
        function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end,
        desc = "Sidekick Toggle Claude",
      },
    },
  },

  -- Amp
  {
    "sourcegraph/amp.nvim",
    branch = "main",
    lazy = false,
    opts = { auto_start = true, log_level = "info" },
  },

  -- Git
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("plugins.config.gitsigns")
    end,
  },
  {
    "sindrets/diffview.nvim",
    keys = {
      { "<leader>do", ":DiffviewOpen<cr>", desc = "Diffview open" },
      { "<leader>dc", ":DiffviewClose<cr>", desc = "Diffview close" },
    },
    cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    config = function()
      require("plugins.config.diffview")
    end,
  },
  {
    "ThePrimeagen/git-worktree.nvim",
    keys = {
      { "<leader>wt", desc = "List/switch worktrees" },
      { "<leader>wT", desc = "Create new worktree" },
      { "<leader>wd", desc = "Delete worktree" },
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local worktree = require("git-worktree")
      local Job = require("plenary.job")

      local function get_worktrees_base_path()
        local result = {}
        Job:new({
          command = "git",
          args = { "rev-parse", "--path-format=absolute", "--git-common-dir" },
          on_exit = function(j, return_val)
            if return_val == 0 then
              result = j:result()
            end
          end,
        }):sync()
        if not result[1] then return nil end
        -- --git-common-dir returns the main repo's .git dir; go up twice to get the parent
        return vim.fn.fnamemodify(result[1], ":h:h")
      end

      local function sanitize_branch_name(branch)
        return branch:gsub("/", "-")
      end

      local function input_in_center(prompt, callback, default_value)
        local buf = vim.api.nvim_create_buf(false, true)
        local width = 60
        local height = 1
        local row = math.floor((vim.o.lines - height) / 2)
        local col = math.floor((vim.o.columns - width) / 2)

        local win = vim.api.nvim_open_win(buf, true, {
          relative = "editor",
          width = width,
          height = height,
          row = row,
          col = col,
          style = "minimal",
          border = "rounded",
          title = prompt,
          title_pos = "center",
        })

        if default_value then
          vim.api.nvim_buf_set_lines(buf, 0, -1, false, { default_value })
        end

        vim.cmd("startinsert!")

        vim.keymap.set("i", "<CR>", function()
          local input = vim.api.nvim_buf_get_lines(buf, 0, -1, false)[1] or ""
          vim.api.nvim_win_close(win, true)
          vim.cmd("stopinsert")
          callback(input)
        end, { buffer = buf })

        vim.keymap.set({ "i", "n" }, "<Esc>", function()
          vim.api.nvim_win_close(win, true)
          vim.cmd("stopinsert")
          callback(nil)
        end, { buffer = buf })
      end

      worktree.setup()

      vim.keymap.set("n", "<leader>wt", function()
        local fzf = require("fzf-lua")

        local results = {}
        Job:new({
          command = "git",
          args = { "worktree", "list" },
          on_exit = function(j, return_val)
            if return_val == 0 then
              results = j:result()
            end
          end,
        }):sync()

        fzf.fzf_exec(results, {
          prompt = "Git Worktrees> ",
          actions = {
            ["default"] = function(selected)
              if selected and selected[1] then
                local path = selected[1]:match("^(%S+)")
                if path then
                  worktree.switch_worktree(path)
                end
              end
            end,
          },
        })
      end, { desc = "List/switch worktrees" })

      vim.keymap.set("n", "<leader>wT", function()
        local base_path = get_worktrees_base_path()
        if not base_path then
          vim.notify("Could not determine repository root", vim.log.levels.ERROR)
          return
        end

        input_in_center("Branch name: ", function(branch)
          if not branch or branch == "" then return end

          local folder_name = sanitize_branch_name(branch)
          local worktree_path = base_path .. "/" .. folder_name

          input_in_center("Base branch (empty for current): ", function(base_branch)
            if base_branch == nil then return end

            if base_branch == "" then
              worktree.create_worktree(worktree_path, branch)
            else
              worktree.create_worktree(worktree_path, branch, base_branch)
            end
            vim.notify("Created worktree: " .. worktree_path, vim.log.levels.INFO)
          end, "staging")
        end)
      end, { desc = "Create new worktree" })

      vim.keymap.set("n", "<leader>wd", function()
        local fzf = require("fzf-lua")

        local results = {}
        Job:new({
          command = "git",
          args = { "worktree", "list" },
          on_exit = function(j, return_val)
            if return_val == 0 then
              results = j:result()
            end
          end,
        }):sync()

        fzf.fzf_exec(results, {
          prompt = "Delete Worktree> ",
          actions = {
            ["default"] = function(selected)
              if selected and selected[1] then
                local path = selected[1]:match("^(%S+)")
                if path then
                  worktree.delete_worktree(path, true)
                  vim.notify("Deleted worktree: " .. path, vim.log.levels.INFO)
                end
              end
            end,
          },
        })
      end, { desc = "Delete worktree" })
    end,
  },
}, {
  -- lazy.nvim options
  ui = {
    border = "rounded",
  },
  change_detection = {
    notify = false,
  },
})

-- Load colorscheme
require("plugins.config.colorscheme")
