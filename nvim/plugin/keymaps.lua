if vim.g.did_load_keymaps_plugin then
  return
end
vim.g.did_load_keymaps_plugin = true

local api = vim.api
local fn = vim.fn
local keymap = vim.keymap
local diagnostic = vim.diagnostic

keymap.set("i", "jk", "<Esc>", { silent = true, desc = "Exit insert mode" })
keymap.set("n", "<leader>w", "<cmd>w<CR>", { silent = true, desc = "Write file" })
keymap.set("n", "<leader>q", "<cmd>q!<CR>", { silent = true, desc = "Quit file" })
-- Move visual block FIXME: doesn't work as expected
keymap.set("v", "J", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move visual block up" })
keymap.set("v", "K", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move visual block down" })
-- Center cursor
keymap.set('n', '<C-d>', '<C-d>zz', { silent = true, desc = 'move [d]own half-page and center' })
keymap.set('n', '<C-u>', '<C-u>zz', { silent = true, desc = 'move [u]p half-page and center' })
keymap.set('n', '<C-f>', '<C-f>zz', { silent = true, desc = 'move DOWN [f]ull-page and center' })
keymap.set('n', '<C-b>', '<C-b>zz', { silent = true, desc = 'move UP full-page and center' })
keymap.set("n", "n", "nzzzv", { silent = true, desc = "Next occurence and center" })
keymap.set("n", "N", "Nzzzv", { silent = true, desc = "Previous occurence and center" })
-- Splittings
keymap.set("n", "<leader>-", "<cmd>split<CR>", { silent = true, desc = "Split pane horizantally" })
keymap.set("n", "<leader>|", "<cmd>vs<CR>", { silent = true, desc = "Split pane vertically" })
keymap.set("n", "<C-h>", "<C-w>h", { silent = true, desc = "Move to left pane" })
keymap.set("n", "<C-j>", "<C-w>j", { silent = true, desc = "Move to down pane" })
keymap.set("n", "<C-k>", "<C-w>k", { silent = true, desc = "Move to up pane" })
keymap.set("n", "<C-l>", "<C-w>l", { silent = true, desc = "Move to right pane" })
-- Copy to global clipboard
keymap.set({ 'n', 'v' }, "<leader>y", "\"+y", { silent = true, desc = "Yank to global clipboard" })
-- Yank from current position till end of current line
keymap.set('n', 'Y', 'y$', { silent = true, desc = '[Y]ank to end of line' })

-- Toggle the quickfix list (only opens if it is populated)
local function toggle_qf_list()
  local qf_exists = false
  for _, win in pairs(fn.getwininfo() or {}) do
    if win['quickfix'] == 1 then
      qf_exists = true
    end
  end
  if qf_exists == true then
    vim.cmd.cclose()
    return
  end
  if not vim.tbl_isempty(vim.fn.getqflist()) then
    vim.cmd.copen()
  end
end

keymap.set('n', '<C-c>', toggle_qf_list, { silent = true, desc = 'toggle quickfix list' })

local function try_fallback_notify(opts)
  local success, _ = pcall(opts.try)
  if success then
    return
  end
  success, _ = pcall(opts.fallback)
  if success then
    return
  end
  vim.notify(opts.notify, vim.log.levels.INFO)
end

-- Cycle the quickfix and location lists
local function cleft()
  try_fallback_notify {
    try = vim.cmd.cprev,
    fallback = vim.cmd.clast,
    notify = 'Quickfix list is empty!',
  }
end

local function cright()
  try_fallback_notify {
    try = vim.cmd.cnext,
    fallback = vim.cmd.cfirst,
    notify = 'Quickfix list is empty!',
  }
end

keymap.set('n', '[c', cleft, { silent = true, desc = '[c]ycle quickfix left' })
keymap.set('n', ']c', cright, { silent = true, desc = '[c]ycle quickfix right' })
keymap.set('n', '[C', vim.cmd.cfirst, { silent = true, desc = 'first quickfix entry' })
keymap.set('n', ']C', vim.cmd.clast, { silent = true, desc = 'last quickfix entry' })

local function lleft()
  try_fallback_notify {
    try = vim.cmd.lprev,
    fallback = vim.cmd.llast,
    notify = 'Location list is empty!',
  }
end

local function lright()
  try_fallback_notify {
    try = vim.cmd.lnext,
    fallback = vim.cmd.lfirst,
    notify = 'Location list is empty!',
  }
end

keymap.set('n', '[l', lleft, { silent = true, desc = 'cycle [l]oclist left' })
keymap.set('n', ']l', lright, { silent = true, desc = 'cycle [l]oclist right' })
keymap.set('n', '[L', vim.cmd.lfirst, { silent = true, desc = 'first [L]oclist entry' })
keymap.set('n', ']L', vim.cmd.llast, { silent = true, desc = 'last [L]oclist entry' })

-- Resize vertical splits
local toIntegral = math.ceil
-- keymap.set('n', '<leader>w+', function()
-- 	local curWinWidth = api.nvim_win_get_width(0)
-- 	api.nvim_win_set_width(0, toIntegral(curWinWidth * 3 / 2))
-- end, { silent = true, desc = 'inc window [w]idth' })
-- keymap.set('n', '<leader>w-', function()
-- 	local curWinWidth = api.nvim_win_get_width(0)
-- 	api.nvim_win_set_width(0, toIntegral(curWinWidth * 2 / 3))
-- end, { silent = true, desc = 'dec window [w]idth' })
keymap.set('n', '<leader>h+', function()
  local curWinHeight = api.nvim_win_get_height(0)
  api.nvim_win_set_height(0, toIntegral(curWinHeight * 3 / 2))
end, { silent = true, desc = 'inc window [h]eight' })
keymap.set('n', '<leader>h-', function()
  local curWinHeight = api.nvim_win_get_height(0)
  api.nvim_win_set_height(0, toIntegral(curWinHeight * 2 / 3))
end, { silent = true, desc = 'dec window [h]eight' })

-- Close floating windows [Neovim 0.10 and above]
keymap.set('n', '<leader>fq', function()
  vim.cmd('fclose!')
end, { silent = true, desc = '[f]loating windows: [q]uit/close all' })

-- Remap Esc to switch to normal mode and Ctrl-Esc to pass Esc to terminal
keymap.set('t', '<Esc>', '<C-\\><C-n>', { silent = true, desc = 'switch to normal mode' })
keymap.set('t', '<C-Esc>', '<Esc>', { silent = true, desc = 'send Esc to terminal' })

-- Shortcut for expanding to current buffer's directory in command mode
keymap.set('c', '%%', function()
  if fn.getcmdtype() == ':' then
    return fn.expand('%:h') .. '/'
  else
    return '%%'
  end
end, { expr = true, desc = "expand to current buffer's directory" })

keymap.set('n', '<leader>tn', vim.cmd.tabnew, { silent = true, desc = '[t]ab: [n]ew' })
keymap.set('n', '<leader>tq', vim.cmd.tabclose, { silent = true, desc = '[t]ab: [q]uit/close' })

local severity = diagnostic.severity

-- keymap.set('n', '<leader>e', function()
--   local _, winid = diagnostic.open_float(nil, { scope = 'line' })
--   if not winid then
--     vim.notify('no diagnostics found', vim.log.levels.INFO)
--     return
--   end
--   vim.api.nvim_win_set_config(winid or 0, { focusable = true })
-- end, { noremap = true, silent = true, desc = 'diagnostics floating window' })
keymap.set('n', '[d', diagnostic.goto_prev, { noremap = true, silent = true, desc = 'previous [d]iagnostic' })
keymap.set('n', ']d', diagnostic.goto_next, { noremap = true, silent = true, desc = 'next [d]iagnostic' })
keymap.set('n', '[e', function()
  diagnostic.goto_prev {
    severity = severity.ERROR,
  }
end, { noremap = true, silent = true, desc = 'previous [e]rror diagnostic' })
keymap.set('n', ']e', function()
  diagnostic.goto_next {
    severity = severity.ERROR,
  }
end, { noremap = true, silent = true, desc = 'next [e]rror diagnostic' })
keymap.set('n', '[w', function()
  diagnostic.goto_prev {
    severity = severity.WARN,
  }
end, { noremap = true, silent = true, desc = 'previous [w]arning diagnostic' })
keymap.set('n', ']w', function()
  diagnostic.goto_next {
    severity = severity.WARN,
  }
end, { noremap = true, silent = true, desc = 'next [w]arning diagnostic' })
keymap.set('n', '[h', function()
  diagnostic.goto_prev {
    severity = severity.HINT,
  }
end, { noremap = true, silent = true, desc = 'previous [h]int diagnostic' })
keymap.set('n', ']h', function()
  diagnostic.goto_next {
    severity = severity.HINT,
  }
end, { noremap = true, silent = true, desc = 'next [h]int diagnostic' })

local function buf_toggle_diagnostics()
  local filter = { bufnr = api.nvim_get_current_buf() }
  diagnostic.enable(not diagnostic.is_enabled(filter), filter)
end

keymap.set('n', '<leader>dt', buf_toggle_diagnostics)

local function toggle_spell_check()
  ---@diagnostic disable-next-line: param-type-mismatch
  vim.opt.spell = not (vim.opt.spell:get())
end

keymap.set('n', '<leader>S', toggle_spell_check, { noremap = true, silent = true, desc = 'toggle [S]pell' })

-- LazyGit
keymap.set('n', '<leader>gg', '<cmd>LazyGit<CR>', { silent = true, desc = 'Open LazyGit' })

--Bufferline
keymap.set("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>", { silent = true, desc = 'Cycle buffers' })
keymap.set("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", { silent = true, desc = 'Cycle reverse buffers' })

-- Buffer
keymap.set('n', '<leader>bd', '<cmd>bd<CR>', { silent = true, desc = 'Open LazyGit' })

-- Neo-tree
keymap.set('n', '<leader>e', "<cmd>Neotree position=left reveal toggle<CR>", { silent = true, desc = 'Toggle neo-tree' })
keymap.set('n', '<leader>o', "<cmd>Neotree position=left focus<CR>", { silent = true, desc = 'Focus neo-tree' })

-- Oil
vim.keymap.set("n", "-", "<cmd>Oil --float<CR>", { silent = true, desc = "Open parent directory" })
