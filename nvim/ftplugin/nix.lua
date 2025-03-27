-- Exit if the language server isn't available
if vim.fn.executable('nixd') ~= 1 then
  return
end

local root_files = {
  'flake.nix',
  'default.nix',
  'shell.nix',
  '.git',
}

local flake = os.getenv('FLAKE')
function get_hostname()
  local f = io.popen("hostname")  -- Runs the hostname command
  if f then
    local hostname = f:read("*l") -- Reads the first line of output
    f:close()
    return hostname
  end
  return nil -- Return nil if the command fails
end

function get_username()
  local f = io.popen("whoami")    -- Works on Linux, macOS, and Windows (cmd)
  if f then
    local username = f:read("*l") -- Read the output
    f:close()
    return username
  end
  return nil
end

require('lspconfig').nixd.setup({
  root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1]),
  capabilities = require('user.lsp').make_client_capabilities(),
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
})
