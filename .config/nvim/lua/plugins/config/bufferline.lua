local status_ok, bufferline = pcall(require, "bufferline")
if not status_ok then
	return
end

bufferline.setup({
	options = {
		numbers = "none", -- | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
		close_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
		right_mouse_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
		left_mouse_command = "buffer %d", -- can be a string | function, see "Mouse actions"
		middle_mouse_command = nil, -- can be a string | function, see "Mouse actions"
		indicator = {
			icon = "▎",
			style = "icon",
		},
		buffer_close_icon = "✕",
		modified_icon = "●",
		close_icon = "✕",
		left_trunc_marker = "",
		right_trunc_marker = "",
		max_name_length = 30,
		max_prefix_length = 30, -- prefix used when a buffer is de-duplicated
		tab_size = 21,
		diagnostics = "nvim_lsp",
		diagnostics_update_in_insert = false,
		diagnostics_indicator = function(count, level)
			local icon = level:match("error") and " " or " "
			return " " .. icon .. count
		end,
		offsets = {
			{
				filetype = "NvimTree",
				text = " File Explorer",
				text_align = "left",
				separator = true,
			},
			{
				filetype = "DiffviewFiles",
				text = " Diff View",
				text_align = "left",
				separator = true,
			},
		},
		color_icons = true,
		show_buffer_icons = true,
		show_buffer_close_icons = false,
		show_close_icon = false,
		show_tab_indicators = false,
		persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
		-- can also be a table containing 2 custom separators
		-- [focused and unfocused]. eg: { '|', '|' }
		separator_style = "thin", -- | "thick" | "thin" | { 'any', 'any' },
		enforce_regular_tabs = false,
		always_show_bufferline = false,
	},
	highlights = {
		error = {
			fg = { attribute = "fg", highlight = "DiagnosticError" },
		},
		error_selected = {
			fg = { attribute = "fg", highlight = "DiagnosticError" },
			italic = true,
			bold = true,
		},
		error_diagnostic_selected = {
			fg = { attribute = "fg", highlight = "DiagnosticError" },
			italic = true,
			bold = true,
		},
		error_diagnostic = {
			fg = { attribute = "fg", highlight = "DiagnosticError" },
		},
		error_visible = {
			fg = { attribute = "fg", highlight = "DiagnosticError" },
		},
		error_diagnostic_visible = {
			fg = { attribute = "fg", highlight = "DiagnosticError" },
		},
		warning = {
			fg = { attribute = "fg", highlight = "DiagnosticWarn" },
		},
		warning_diagnostic = {
			fg = { attribute = "fg", highlight = "DiagnosticWarn" },
		},
		warning_selected = {
			fg = { attribute = "fg", highlight = "DiagnosticWarn" },
			bold = true,
			italic = true,
		},
		warning_diagnostic_selected = {
			fg = { attribute = "fg", highlight = "DiagnosticWarn" },
			bold = true,
			italic = true,
		},
		warning_visible = {
			fg = { attribute = "fg", highlight = "DiagnosticWarn" },
		},
		warning_diagnostic_visible = {
			fg = { attribute = "fg", highlight = "DiagnosticWarn" },
		},
		info = {
			fg = { attribute = "fg", highlight = "DiagnosticInfo" },
		},
		info_diagnostic = {
			fg = { attribute = "fg", highlight = "DiagnosticInfo" },
		},
		info_selected = {
			fg = { attribute = "fg", highlight = "DiagnosticInfo" },
			bold = true,
			italic = true,
		},
		info_diagnostic_selected = {
			fg = { attribute = "fg", highlight = "DiagnosticInfo" },
			bold = true,
			italic = true,
		},
		info_visible = {
			fg = { attribute = "fg", highlight = "DiagnosticInfo" },
		},
		info_diagnostic_visible = {
			fg = { attribute = "fg", highlight = "DiagnosticInfo" },
		},
		hint = {
			fg = { attribute = "fg", highlight = "DiagnosticHint" },
		},
		hint_diagnostic = {
			fg = { attribute = "fg", highlight = "DiagnosticHint" },
		},
		hint_selected = {
			fg = { attribute = "fg", highlight = "DiagnosticHint" },
			bold = true,
			italic = true,
		},
		hint_diagnostic_selected = {
			fg = { attribute = "fg", highlight = "DiagnosticHint" },
			bold = true,
			italic = true,
		},
		hint_visible = {
			fg = { attribute = "fg", highlight = "DiagnosticHint" },
		},
		hint_diagnostic_visible = {
			fg = { attribute = "fg", highlight = "DiagnosticHint" },
		},
	},
})

-- Buffer navigation keymaps (modern API)
vim.keymap.set("n", "<A-,>", ":BufferLineCyclePrev<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<A-.>", ":BufferLineCycleNext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<A->>", ":BufferLineMoveNext<CR>", { desc = "Move buffer right" })
vim.keymap.set("n", "<A-<>", ":BufferLineMovePrev<CR>", { desc = "Move buffer left" })
vim.keymap.set("n", "<space>bl", ":BufferLineCloseLeft<CR>", { desc = "Close buffers to the left" })
vim.keymap.set("n", "<space>br", ":BufferLineCloseRight<CR>", { desc = "Close buffers to the right" })
vim.keymap.set("n", "<A-c>", ":Bdelete<CR>", { desc = "Close current buffer" })
vim.keymap.set("n", "<C-s>", ":BufferLinePick<CR>", { desc = "Pick buffer" })
