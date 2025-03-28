-- Utility
local flake = os.getenv('FLAKE') -- The FLAKE env var is passed by my NixOS conf
-- Retrieve the hostname  using `hostname` command
local function get_hostname()
  local f = io.popen("hostname")  -- Runs the hostname command
  if f then
    local hostname = f:read("*l") -- Reads the first line of output
    f:close()
    return hostname
  end
  return nil
end

-- Retrieve the user name  using `whoami` command
local function get_username()
  local f = io.popen("whoami")    -- Works on Linux, macOS, and Windows (cmd)
  if f then
    local username = f:read("*l") -- Read the output
    f:close()
    return username
  end
  return nil
end

-- LSP configuration
require('lspconfig').nixd.setup {
  capabilities = require('user.lsp').make_client_capabilities(),
  on_attach = require('lsp-format').on_attach,
  cmd = { "nixd" },
  settings = {
    nixd = {
      nixpkgs = {
        expr = "import <nixpkgs> { }",
      },
      formatting = {
        command = { 'nixfmt' },
      },
      options = {
        nixos = {
          expr = '(builtins.getFlake "' .. flake .. '").nixosConfigurations.' .. get_hostname() .. '.options',
        },
        home_manager = {
          expr = '(builtins.getFlake "' .. flake .. '").homeConfigurations.' .. get_username() .. '.options',
        },
      },
    },
  },
}
