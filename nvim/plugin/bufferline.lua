if vim.g.did_load_bufferline_plugin then
	return
end
vim.g.did_load_bufferline_plugin = true

require('bufferline').setup {
	options = {
		separator_style = "thick",
		always_show_bufferline = false,
	},
}
