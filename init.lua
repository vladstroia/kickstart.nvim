-- Set <space> as the leader key
--  
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = false

local function toggle_line_numbers()
  local number = vim.wo.number
  local relativenumber = vim.wo.relativenumber

  if number or relativenumber then
    vim.opt.number = false
    vim.opt.relativenumber = false
    print 'Line numbers: OFF'
  else
    vim.opt.number = true
    vim.opt.relativenumber = true
    print 'Line numbers: ON'
  end
end
vim.api.nvim_create_user_command('ToggleLineNumbers', toggle_line_numbers, {})
vim.keymap.set('n', '<leader>tn', ':ToggleLineNumbers<CR>', { noremap = true, silent = true, desc = 'Toggle Line Numbers' })
vim.o.autowriteall = true
-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

vim.opt.spelllang = 'en_us'
vim.opt.spell = true


-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.opt.clipboard = 'unnamedplus'

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require 'pluggins'

require('lazy').setup {
  { 'nvim-lua/plenary.nvim' },
}

local function get_extension(filename)
  return filename:match '^.+(%..+)$'
end

local function get_base_name(filename)
  return filename:match '(.+)%..+$'
end

function OwlNavigate()
  local current_file = vim.fn.expand '%:p'
  local extension = get_extension(current_file)
  local base_name = get_base_name(current_file)
  local target_extension = extension == '.xml' and '.js' or '.xml'
  vim.cmd('edit ' .. base_name .. target_extension)
end

-- Set up key binding for navigation
vim.api.nvim_set_keymap('n', '<leader>n', ':lua OwlNavigate()<CR>', { noremap = true, silent = true })
vim.opt['tabstop'] = 4
vim.opt['shiftwidth'] = 4

require 'my_config'

-- vim.keymap.set('n', '<leader>o', '<CMD>Oil<CR><C-p>', { desc = 'Open Oil.nvim with preview mode' })
vim.keymap.set('n', '<leader>o', function()
  -- vim.cmd 'Oil'
  require("oil").open()
  -- require("oil").get_cursor_entry()
  require("oil").open_preview()

end, { desc = 'Open Oil.nvim with preview mode' })

-- vim.api.nvim_create_autocmd({'BufWritePost'}, {
--   pattern = '*.js',
--   callback = function()
--     local eslint_config_path = '/home/vlad/odoo-src/odoo/addons/web/tooling/_eslintrc.json'
--     local file_path = vim.fn.expand('%:p')  -- Get the absolute path of the current file
--     local command = string.format('eslint --no-ignore --fix --no-eslintrc -c %s %s',
--                                   vim.fn.shellescape(eslint_config_path),
--                                   vim.fn.shellescape(file_path))
--     os.execute(command)
--     -- Force save the buffer to reflect ESLint changes
--     -- vim.cmd('write!')
--     -- -- Reload the current buffer
--     vim.cmd('e!')
--   end,
-- })
-- vim.api.nvim_create_autocmd('BufLeave', {
--   pattern = '*',
--   callback = function()
--     -- Save all buffers when focus is lost
--     vim.cmd('wa')
--   end,
-- })
--
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
--
