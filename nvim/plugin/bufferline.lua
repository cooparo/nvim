if vim.g.did_load_bufferline_plugin then
	return
end
vim.g.did_load_bufferline_plugin = true

--Bufferline
vim.keymap.set("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>")
vim.keymap.set("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>")

require('bufferline').setup {
	options = {
		separator_style = "thick",
		always_show_bufferline = false,
	},
}
