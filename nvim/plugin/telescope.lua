if vim.g.did_load_telescope_plugin then
  return
end
vim.g.did_load_telescope_plugin = true

local telescope = require('telescope')
local actions = require('telescope.actions')

local builtin = require('telescope.builtin')

local layout_config = {
  vertical = {
    width = function(_, max_columns)
      return math.floor(max_columns * 0.99)
    end,
    height = function(_, _, max_lines)
      return math.floor(max_lines * 0.99)
    end,
    prompt_position = 'bottom',
    preview_cutoff = 0,
  },
}

-- Fall back to find_files if not in a git repo
local project_files = function()
  local opts = {} -- define here if you want to define something
  local ok = pcall(builtin.git_files, opts)
  if not ok then
    builtin.find_files(opts)
  end
end

---@param picker function the telescope picker to use
local function grep_current_file_type(picker)
  local current_file_ext = vim.fn.expand('%:e')
  local additional_vimgrep_arguments = {}
  if current_file_ext ~= '' then
    additional_vimgrep_arguments = {
      '--type',
      current_file_ext,
    }
  end
  local conf = require('telescope.config').values
  picker {
    vimgrep_arguments = vim.tbl_flatten {
      conf.vimgrep_arguments,
      additional_vimgrep_arguments,
    },
  }
end

--- Grep the string under the cursor, filtering for the current file type
local function grep_string_current_file_type()
  grep_current_file_type(builtin.grep_string)
end

--- Live grep, filtering for the current file type
local function live_grep_current_file_type()
  grep_current_file_type(builtin.live_grep)
end

--- Like live_grep, but fuzzy (and slower)
local function fuzzy_grep(opts)
  opts = vim.tbl_extend('error', opts or {}, { search = '', prompt_title = 'Fuzzy grep' })
  builtin.grep_string(opts)
end

local function fuzzy_grep_current_file_type()
  grep_current_file_type(fuzzy_grep)
end

vim.keymap.set('n', '<leader><leader>', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fr', builtin.oldfiles, { desc = 'Telescope old files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fz', fuzzy_grep, { desc = 'Telescope fuzzy grep' })
vim.keymap.set('n', '<leader>tt', '<cmd>TodoTelescope keywords=TODO,FIX<cr>', { desc = 'Telescope fuzzy grep' })
-- # TODO: assign keymap
-- vim.keymap.set('n', '<leader>f', fuzzy_grep_current_file_type, { desc = 'Telescope fuzzy grep filetype' })
-- vim.keymap.set('n', '<leader>f', live_grep_current_file_type, { desc = 'Telescope live grep filetype' })
-- vim.keymap.set(
-- 	'n',
-- 	'<leader>t*',
-- 	grep_string_current_file_type,
-- 	{ desc = '[t]elescope grep current string [*] in current filetype' }
-- )
vim.keymap.set('n', '<leader>*', builtin.grep_string, { desc = 'Telescope grep current string [*]' })
-- vim.keymap.set('n', '<leader>tg', project_files, { desc = 'Telescope project files [g]' })
vim.keymap.set('n', '<leader>tc', builtin.quickfix, { desc = '[t]elescope quickfix list [c]' })
-- vim.keymap.set('n', '<leader>tq', builtin.command_history, { desc = '[t]elescope command history [q]' })
vim.keymap.set('n', '<leader>tl', builtin.loclist, { desc = '[t]elescope [l]oclist' })
vim.keymap.set('n', '<leader>tr', builtin.registers, { desc = '[t]elescope [r]egisters' })
vim.keymap.set('n', '<leader>tbb', builtin.buffers, { desc = '[t]elescope [b]uffers [b]' })
vim.keymap.set('n', '<leader>ht', builtin.help_tags, { desc = 'telescope [h]elp_[t]ags' })
-- vim.keymap.set(
-- 	'n',
-- 	'<leader>tbf',
-- 	builtin.current_buffer_fuzzy_find,
-- 	{ desc = '[t]elescope current [b]uffer [f]uzzy find' }
-- )
-- vim.keymap.set('n', '<leader>td', builtin.lsp_document_symbols, { desc = '[t]elescope lsp [d]ocument symbols' })
-- vim.keymap.set(
-- 	'n',
-- 	'<leader>to',
-- 	builtin.lsp_dynamic_workspace_symbols,
-- 	{ desc = '[t]elescope lsp dynamic w[o]rkspace symbols' }
-- )

telescope.setup {
  defaults = {
    path_display = {
      'truncate',
    },
    -- layout_strategy = '',
    -- layout_config = layout_config,
    mappings = {
      i = {
        ['<esc>'] = actions.close,
        -- ['<C-q>'] = actions.send_to_qflist,
        -- ['<C-l>'] = actions.send_to_loclist,
        ['<C-s>'] = actions.cycle_previewers_next,
        ['<C-a>'] = actions.cycle_previewers_prev,
      },
      n = {
        ['<esc>'] = actions.close,
      },
    },
    preview = {
      treesitter = true,
    },
    history = {
      path = vim.fn.stdpath('data') .. '/telescope_history.sqlite3',
      limit = 1000,
    },
    color_devicons = true,
    set_env = { ['COLORTERM'] = 'truecolor' },
    prompt_prefix = '   ',
    selection_caret = '  ',
    entry_prefix = '  ',
    initial_mode = 'insert',
    vimgrep_arguments = {
      'rg',
      '-L',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,                   -- Enable fuzzy search
      override_generic_sorter = true, -- Override the generic sorter
      override_file_sorter = true,    -- Override the file sorter
      case_mode = "smart_case",       -- "smart_case" | "ignore_case" | "respect_case"
    },
  },
}

-- telescope.load_extension('fzy_native')
-- telescope.load_extension('smart_history')
