if vim.g.did_load_alpha_plugin then
  return
end
vim.g.did_load_alpha_plugin = true

local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

-- Set header (ASCII art)
dashboard.section.header.val = {
  "                                                      ",
  "                                                      ",
  "                                                      ",
  "                                                      ",
  "░▒▓███████▓▒░ ░▒▓██████▓▒░░▒▓███████▓▒░ ░▒▓██████▓▒░  ",
  "░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ ",
  "░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ ",
  "░▒▓███████▓▒░░▒▓████████▓▒░▒▓███████▓▒░░▒▓█▓▒░░▒▓█▓▒░ ",
  "░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ ",
  "░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ ",
  "░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓██████▓▒░  ",
  "                                                      ",
  "          from git@github.com:cooparo",
  "                                                      ",
  "                                                      ",
  "                                                      ",
  "                                                      ",
  "                                                      ",
}

-- Set menu (keybindings)
dashboard.section.buttons.val = {
  dashboard.button("r", "  Recents", function()
    require("telescope.builtin").oldfiles({ cwd_only = true })
  end),
  dashboard.button("f", "  Explore", "<cmd>Telescope find_files<CR>"),
  dashboard.button("G", "  Ripgrep", "<cmd>Telescope live_grep<CR>"),
  dashboard.button("l", "  LazyGit", "<cmd>LazyGit<CR>"),
  dashboard.button("t", "  TODOs", "<cmd>TodoTelescope keywords=TODO,FIX<CR>"),
  dashboard.button("q", "󰈆  Quit", "<cmd>q<CR>"),
}

alpha.setup(dashboard.opts)

-- Disable folding on alpha buffer
vim.cmd([[
    autocmd FileType alpha setlocal nofoldenable
]])
