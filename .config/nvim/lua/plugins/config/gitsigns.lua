local status_ok, gitsigns = pcall(require, "gitsigns")
if not status_ok then
	return
end

gitsigns.setup({
	signs = {
		add = { hl = "GitSignsAdd", text = "▎", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
		change = { hl = "GitSignsChange", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
		delete = { hl = "GitSignsDelete", text = "_", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
		topdelete = { hl = "GitSignsDelete", text = "‾", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
		changedelete = {
			hl = "GitSignsChange",
			text = "▎",
			numhl = "GitSignsChangeNr",
			linehl = "GitSignsChangeLn",
		},
	},
	signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
	numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
	linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
	word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
	watch_gitdir = {
		interval = 1000,
		follow_files = true,
	},
	attach_to_untracked = true,
	current_line_blame = false, -- Toggle with <space>tb when needed
	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
		delay = 500, -- Faster than default
		ignore_whitespace = false,
		virt_text_priority = 100,
	},
	current_line_blame_formatter = '  <author>, <author_time:%Y-%m-%d> • <summary>',
	sign_priority = 6,
	update_debounce = 100,
	status_formatter = nil, -- Use default
	max_file_length = 40000,
	preview_config = {
		-- Options passed to nvim_open_win
		border = "single",
		style = "minimal",
		relative = "cursor",
		row = 0,
		col = 1,
	},
	on_attach = function(bufnr)
		local gs = package.loaded.gitsigns

		-- Navigation
		vim.keymap.set("n", "]h", function()
			if vim.wo.diff then
				return "]c"
			end
			vim.schedule(function()
				gs.next_hunk()
			end)
			return "<Ignore>"
		end, { expr = true, buffer = bufnr, desc = "Next git hunk" })

		vim.keymap.set("n", "[h", function()
			if vim.wo.diff then
				return "[c"
			end
			vim.schedule(function()
				gs.prev_hunk()
			end)
			return "<Ignore>"
		end, { expr = true, buffer = bufnr, desc = "Previous git hunk" })

		-- Actions
		vim.keymap.set("n", "<space>hs", gs.stage_hunk, { buffer = bufnr, desc = "Stage hunk" })
		vim.keymap.set("n", "<space>hr", gs.reset_hunk, { buffer = bufnr, desc = "Reset hunk" })
		vim.keymap.set("v", "<space>hs", function()
			gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { buffer = bufnr, desc = "Stage hunk (visual)" })
		vim.keymap.set("v", "<space>hr", function()
			gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { buffer = bufnr, desc = "Reset hunk (visual)" })
		vim.keymap.set("n", "<space>hS", gs.stage_buffer, { buffer = bufnr, desc = "Stage buffer" })
		vim.keymap.set("n", "<space>hu", gs.undo_stage_hunk, { buffer = bufnr, desc = "Undo stage hunk" })
		vim.keymap.set("n", "<space>hR", gs.reset_buffer, { buffer = bufnr, desc = "Reset buffer" })
		vim.keymap.set("n", "<space>hp", gs.preview_hunk, { buffer = bufnr, desc = "Preview hunk" })
		vim.keymap.set("n", "<space>hb", function()
			gs.blame_line({ full = true })
		end, { buffer = bufnr, desc = "Blame line (full)" })
		vim.keymap.set("n", "<space>tb", gs.toggle_current_line_blame, { buffer = bufnr, desc = "Toggle git blame" })
		vim.keymap.set("n", "<space>hd", gs.diffthis, { buffer = bufnr, desc = "Diff this" })
		vim.keymap.set("n", "<space>hD", function()
			gs.diffthis("~")
		end, { buffer = bufnr, desc = "Diff this ~" })
		vim.keymap.set("n", "<space>td", gs.toggle_deleted, { buffer = bufnr, desc = "Toggle deleted" })

		-- Text object
		vim.keymap.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { buffer = bufnr, desc = "Select hunk" })
	end,
})
