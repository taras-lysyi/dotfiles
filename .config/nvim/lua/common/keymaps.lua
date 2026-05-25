-- Remap , as leader key
vim.keymap.set("", ",", "<Nop>", { desc = "Disable comma" })
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Better window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Navigate left" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Navigate down" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Navigate up" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Navigate right" })
vim.keymap.set("i", "<C-h>", "<C-\\><C-N><C-w>h", { desc = "Navigate left (insert mode)" })
vim.keymap.set("i", "<C-j>", "<C-\\><C-N><C-w>j", { desc = "Navigate down (insert mode)" })
vim.keymap.set("i", "<C-k>", "<C-\\><C-N><C-w>k", { desc = "Navigate up (insert mode)" })
vim.keymap.set("i", "<C-l>", "<C-\\><C-N><C-w>l", { desc = "Navigate right (insert mode)" })
vim.keymap.set("t", "<C-h>", "<C-\\><C-N><C-w>h", { desc = "Navigate left (terminal mode)" })
vim.keymap.set("t", "<C-j>", "<C-\\><C-N><C-w>j", { desc = "Navigate down (terminal mode)" })
vim.keymap.set("t", "<C-k>", "<C-\\><C-N><C-w>k", { desc = "Navigate up (terminal mode)" })
vim.keymap.set("t", "<C-l>", "<C-\\><C-N><C-w>l", { desc = "Navigate right (terminal mode)" })

-- Resize with arrows
vim.keymap.set("n", "<C-Up>", ":resize -6<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Down>", ":resize +6<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Right>", ":vertical resize -6<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Left>", ":vertical resize +6<CR>", { desc = "Increase window width" })
vim.keymap.set("i", "<C-Up>", "<C-\\><C-N> :resize -6<CR>", { desc = "Decrease window height (insert mode)" })
vim.keymap.set("i", "<C-Down>", "<C-\\><C-N> :resize +6<CR>", { desc = "Increase window height (insert mode)" })
vim.keymap.set("i", "<C-Right>", "<C-\\><C-N> :vertical resize -6<CR>", { desc = "Decrease window width (insert mode)" })
vim.keymap.set("i", "<C-Left>", "<C-\\><C-N> :vertical resize +6<CR>", { desc = "Increase window width (insert mode)" })
vim.keymap.set("t", "<C-Up>", "<C-\\><C-N> :resize -6<CR>", { desc = "Decrease window height (terminal mode)" })
vim.keymap.set("t", "<C-Down>", "<C-\\><C-N> :resize +6<CR>", { desc = "Increase window height (terminal mode)" })
vim.keymap.set("t", "<C-Right>", "<C-\\><C-N> :vertical resize -6<CR>", { desc = "Decrease window width (terminal mode)" })
vim.keymap.set("t", "<C-Left>", "<C-\\><C-N> :vertical resize +6<CR>", { desc = "Increase window width (terminal mode)" })

vim.keymap.set("n", "<C-w>t", ":tab split<CR>", { desc = "Open in new tab" })
vim.keymap.set("n", "<C-w>s", ":vsplit<CR>", { desc = "Vertical split" })
vim.keymap.set("n", "<C-w>i", ":split<CR>", { desc = "Horizontal split" })

-- move lines
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

vim.keymap.set("n", "\\", ":noh<CR>", { desc = "Clear search highlight" })
-- Don't yank on visual paste
vim.keymap.set("v", "p", '"_dP', { desc = "Paste without yanking" })
vim.keymap.set("n", "]q", ":cn<CR>", { desc = "Next quickfix item" })
vim.keymap.set("n", "[q", ":cp<CR>", { desc = "Previous quickfix item" })

vim.keymap.set("n", "]d", function() require("utils.ts_usages").next() end, { desc = "Next usage of word under cursor" })
vim.keymap.set("n", "[d", function() require("utils.ts_usages").prev() end, { desc = "Prev usage of word under cursor" })

-- remove /n on copy in terminal with C-v
-- used for copying to clipboard in terminal
vim.cmd([[
  vmap <C-C> "+y:let @+ = substitute(@+, "\n\n\n*", "±", "g")
  \\|:let @+ = substitute(@+, "\n", "", "g")<CR>
   \\|:let @+ = substitute(@+, "±", "\\n", "g")<CR>
   \\|'<
]])

vim.keymap.set("n", "<space>q", ":q<CR>", { desc = "Quit" })
vim.keymap.set("n", "<space>Q", ":qa<CR>", { desc = "Quit all" })
vim.keymap.set("n", "<space>w", ":w<CR>", { desc = "Write" })
vim.keymap.set("n", "<space>W", ":wa<CR>", { desc = "Write all" })
vim.keymap.set("n", "<space>z", ":wq<CR>", { desc = "Write and quit" })

vim.keymap.set("n", "<space>f", ":Format<CR>", { desc = "Format buffer" })

-- exit terminal mode
vim.keymap.set("t", "<A-\\>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Disable accidentally pressing ctrl-z and suspending
vim.keymap.set("n", "<C-z>", "<Nop>", { desc = "Disable suspend" })
-- Yank without cursor movement
vim.keymap.set("v", "y", "y`]", { desc = "Yank without cursor movement" })

-- Workspace management (like Cursor workspaces)
vim.keymap.set("n", "<leader>wa", ":lua require('workspaces').add()<CR>", { desc = "Add current dir as workspace" })
vim.keymap.set("n", "<leader>wr", ":lua require('workspaces').remove()<CR>", { desc = "Remove workspace" })
vim.keymap.set("n", "<leader>wl", function()
  local workspaces = require("workspaces")
  local fzf = require("fzf-lua")
  local ws_list = workspaces.get()
  local entries = {}
  for _, ws in ipairs(ws_list) do
    table.insert(entries, ws.name .. " : " .. ws.path)
  end
  fzf.fzf_exec(entries, {
    prompt = "Workspaces> ",
    actions = {
      ["default"] = function(selected)
        if selected and selected[1] then
          local name = selected[1]:match("^(.-)%s*:")
          workspaces.open(name)
        end
      end
    }
  })
end, { desc = "List/switch workspaces" })
vim.keymap.set("n", "<leader>wo", ":lua require('workspaces').open()<CR>", { desc = "Open workspace" })

