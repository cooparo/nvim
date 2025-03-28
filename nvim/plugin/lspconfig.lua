if vim.g.did_load_lspconfig_plugin then
  return
end
vim.g.did_load_lspconfig_plugin = true

vim.cmd.highlight("TSConstant gui=bold")
