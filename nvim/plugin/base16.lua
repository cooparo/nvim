if vim.g.did_load_base16_plugin then
  return
end
vim.g.did_load_base16_plugin = true

-- I'm using env variables to get the system theme
-- variables are defined in my NixOS config
-- fallback to Tokyo Night dark colorscheme
-- (https://github.com/tinted-theming/base16-schemes/blob/main/tokyo-night-dark.yaml)
local base00 = os.getenv("BASE00") or "#1a1b26"
local base01 = os.getenv("BASE01") or "#16161e"
local base02 = os.getenv("BASE02") or "#2f3549"
local base03 = os.getenv("BASE03") or "#444b6a"
local base04 = os.getenv("BASE04") or "#787c99"
local base05 = os.getenv("BASE05") or "#a9b1d6"
local base06 = os.getenv("BASE06") or "#cbccd1"
local base07 = os.getenv("BASE07") or "#d5d6db"
local base08 = os.getenv("BASE08") or "#c0caf5"
local base09 = os.getenv("BASE09") or "#a9b1d6"
local base0A = os.getenv("BASE0A") or "#0db9d7"
local base0B = os.getenv("BASE0B") or "#9ece6a"
local base0C = os.getenv("BASE0C") or "#b4f9f8"
local base0D = os.getenv("BASE0D") or "#2ac3de"
local base0E = os.getenv("BASE0E") or "#bb9af7"
local base0F = os.getenv("BASE0F") or "#f7768e"

require('base16-colorscheme').setup({
  base00 = base00,
  base01 = base01,
  base02 = base02,
  base03 = base03,
  base04 = base04,
  base05 = base05,
  base06 = base06,
  base07 = base07,
  base08 = base08,
  base09 = base09,
  base0A = base0A,
  base0B = base0B,
  base0C = base0C,
  base0D = base0D,
  base0E = base0E,
  base0F = base0F,
})
