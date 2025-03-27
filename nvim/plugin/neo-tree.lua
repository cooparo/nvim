if vim.g.did_load_neotree_plugin then
  return
end
vim.g.did_load_neotree_plugin = true

require("neo-tree").setup({
  popup_border_style = "rounded", -- "double", "none", "rounded", "shadow", "single" or "solid"
  close_if_last_window = true,

  filesystem = {
    follow_current_file = { enabled = true }, -- Automatically expand the directory of the current file
    use_libuv_file_watcher = true,          -- Automatically refresh the tree when files change

    always_show = {                         -- remains visible even if other settings would normally hide it
      ".gitignore",
    },
  },
  window = {
    width = "30",
    auto_expand_width = true, -- Automatically resize the width of the Neo-tree window

    mappings = {
      ["P"] = {
        "toggle_preview",
        config = {
          use_float = true,
          -- use_image_nvim = true,
          -- title = 'Neo-tree Preview',
        },
      },
    }
  },
  default_component_configs = {
    indent = {
      padding = 2, -- Set padding to make expansions visually clearer
    },
  },
})
