-- ========================================================================== --
-- ==                           EDITOR SETTINGS                            == --
-- ========================================================================== --

-- Learn more about Neovim lua api
-- https://neovim.io/doc/user/lua-guide.html
-- https://vonheikemen.github.io/devlog/tools/build-your-first-lua-config-for-neovim/

vim.o.number = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = false
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.showmode = false
vim.o.termguicolors = true
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.signcolumn = 'yes'
vim.o.undofile = true
vim.o.mouse = 'a'
vim.opt.clipboard = "unnamedplus"
-- Space as leader key
vim.g.mapleader = ' '

-- Basic clipboard interaction
--vim.keymap.set({ 'n', 'x' }, 'gy', '"+y', { desc = 'Copy to clipboard' })
--vim.keymap.set({ 'n', 'x' }, 'gp', '"+p', { desc = 'Paste clipboard content' })

-- ========================================================================== --
-- ==                               PLUGINS                                == --
-- ========================================================================== --

local mini = {}
mini.branch = 'main'

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

if not (vim.uv or vim.loop).fs_stat(lazypath) then
	print('Installing lazy.nvim....')

	vim.fn.system({
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable',
		lazypath
	})

	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ 'Failed to install lazy.nvim.\n', 'ErrorMsg' },
			{ vim.fn.system('git --version'),   'WarningMsg' },
			{ '\nPress any key to exit...' },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
	'folke/which-key.nvim',
	{
		'nvim-mini/mini.nvim',
		branch = mini.branch,
	},
	'neovim/nvim-lspconfig',
	{
		'williamboman/mason.nvim',
		build = function()
			-- `:MasonUpdate` is only available after mason.setup() defines user commands.
			-- Use the Lua API in build to avoid command timing issues.
			require('mason').setup({})
			require('mason-registry').refresh()
		end,
	},
	'williamboman/mason-lspconfig.nvim',
	'nvim-lua/plenary.nvim',
	'nvim-telescope/telescope.nvim',
	{
		'Saghen/blink.cmp',
		version = '1.*',
	},
	{
		'nvim-treesitter/nvim-treesitter',
		branch = 'main',
		build = ':TSUpdate',
	},
}, {
	defaults = {
		lazy = false,
	},
})

-- ========================================================================== --
-- ==                         PLUGIN CONFIGURATION                         == --
-- ========================================================================== --

vim.cmd.colorscheme('habamax')

-- See :help MiniAi-textobject-builtin
require('mini.ai').setup({ n_lines = 500 })

-- See :help MiniComment.config
require('mini.comment').setup({})

-- See :help MiniSurround.config
require('mini.surround').setup({})

-- See :help MiniBufremove.config
require('mini.bufremove').setup({})

-- Close buffer and preserve window layout
vim.keymap.set('n', '<leader>bc', '<cmd>lua pcall(MiniBufremove.delete)<cr>', { desc = 'Close buffer' })

-- Open netrw explorer
vim.keymap.set('n', '<leader>e', '<cmd>Explore<cr>', { desc = 'File explorer' })

require('telescope').setup({})
local telescope_builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>?', telescope_builtin.oldfiles, { desc = 'Search file history' })
vim.keymap.set('n', '<leader><space>', telescope_builtin.buffers, { desc = 'Search open files' })
vim.keymap.set('n', '<leader>sf', telescope_builtin.find_files, { desc = 'Search all files' })
vim.keymap.set('n', '<leader>sg', telescope_builtin.live_grep, { desc = 'Search in project' })
vim.keymap.set('n', '<leader>sd', telescope_builtin.diagnostics, { desc = 'Search diagnostics' })
vim.keymap.set('n', '<leader>ss', telescope_builtin.current_buffer_fuzzy_find, { desc = 'Buffer local search' })

-- See :help MiniStatusline.config
-- require('mini.statusline').setup({})

-- See :help MiniSnippets.config
require('mini.snippets').setup({})

require('blink.cmp').setup({
	keymap = {
		preset = 'default',
		['<CR>'] = { 'accept', 'fallback' },
	},
	sources = {
		default = { 'lsp', 'path', 'snippets', 'buffer' },
		providers = {
			path = {
				opts = {
					-- Optional: make path completion relative to project cwd
					get_cwd = function(_)
						return vim.fn.getcwd()
					end,
				},
			},
		},
	},
	completion = {
		list = {
			selection = {
				preselect = true,
				auto_insert = false,
			},
		},
		menu = {
			draw = {
				columns = {
					{ 'label', 'label_description', gap = 1 },
					{ 'kind' },
				},
			},
		},
	},
})

-- See :help which-key.nvim-which-key-setup
require('which-key').setup({
	icons = {
		mappings = false,
		keys = {
			Space = 'Space',
			Esc = 'Esc',
			BS = 'Backspace',
			C = 'Ctrl-',
		},
	},
})

require('which-key').add({
	{ '<leader>f', group = 'Fuzzy Find' },
	{ '<leader>b', group = 'Buffer' },
	{ '<leader>l', group = 'LSP' },
	{ '<leader>d', group = 'Diagnostics' },
	{ 'g',         group = 'Goto/LSP' },
})

-- Quick diagnostic navigation
vim.keymap.set('n', '[d', function()
	vim.diagnostic.jump({ count = -1, float = true })
end, { desc = 'Prev diagnostic' })
vim.keymap.set('n', ']d', function()
	vim.diagnostic.jump({ count = 1, float = true })
end, { desc = 'Next diagnostic' })
vim.keymap.set('n', '<leader>ld', vim.diagnostic.open_float, { desc = 'Line diagnostics' })

-- Treesitter setup
local ts_parsers = { 'lua', 'vim', 'vimdoc', 'c', 'query' }

require('nvim-treesitter').install(ts_parsers)

local ts = vim.treesitter
local ts_filetypes = vim.iter(ts_parsers)
		:map(ts.language.get_filetypes)
		:flatten()
		:fold({}, function(tbl, v)
			tbl[v] = true
			return tbl
		end)

vim.api.nvim_create_autocmd('FileType', {
	desc = 'enable treesitter',
	callback = function(event)
		local ft = event.match
		if ts_filetypes[ft] == nil then
			return
		end

		local lang = ts.language.get_lang(ft)
		local ok, hl = pcall(ts.query.get, lang, 'highlights')

		if ok and hl then
			ts.start(event.buf, lang)
		end
	end,
})

vim.api.nvim_create_autocmd('LspAttach', {
	desc = 'LSP actions',
	callback = function(event)
		local opts = { buffer = event.buf }

		-- These keymaps will become defaults after Neovim v0.11
		-- I've added them here for backwards compatibility
		vim.keymap.set('n', 'grr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
		vim.keymap.set('n', 'gri', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
		vim.keymap.set('n', 'grt', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
		vim.keymap.set('n', 'grn', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
		vim.keymap.set('n', 'gra', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
		vim.keymap.set('n', 'gO', '<cmd>lua vim.lsp.buf.document_symbol()<cr>', opts)
		vim.keymap.set({ 'i', 's' }, '<C-s>', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)

		-- These are custom keymaps
		vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
		vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
		vim.keymap.set('n', 'grd', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
		vim.keymap.set({ 'n', 'x' }, 'gq', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
		vim.keymap.set('n', '<leader>lf', function()
			vim.lsp.buf.format({ async = true })
		end, vim.tbl_extend('keep', { desc = 'Format buffer' }, opts))
		vim.keymap.set('n', '<leader>la', '<cmd>lua vim.lsp.buf.code_action()<cr>',
			vim.tbl_extend('keep', { desc = 'Code action' }, opts))
		vim.keymap.set('n', '<leader>lr', '<cmd>lua vim.lsp.buf.rename()<cr>',
			vim.tbl_extend('keep', { desc = 'Rename symbol' }, opts))
	end,
})

-- Auto-format on save

if not vim.g.vscode then
	vim.api.nvim_create_autocmd('BufWritePre', {
		callback = function(event)
			-- Check if there's an LSP client attached
			local clients = vim.lsp.get_clients({ bufnr = event.buf })
			if #clients > 0 then
				vim.lsp.buf.format({ async = false, bufnr = event.buf })
			end
		end,
	})
end

-- ======================================================================= --
-- ==                         LSP CONFIGURATION                         == --
-- ======================================================================= --

vim.lsp.config('lua_ls', {
	on_init = function(client)
		if client.workspace_folders then
			local path = client.workspace_folders[1].name
			if
					path ~= vim.fn.stdpath('config')
					and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
			then
				return
			end
		end

		client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
			runtime = {
				version = 'LuaJIT',
				path = {
					'lua/?.lua',
					'lua/?/init.lua',
				},
			},
			-- Make the server aware of Neovim runtime files
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME
					-- '${3rd}/luv/library'
					-- '${3rd}/busted/library'
				}
			}
		})
	end,
	settings = {
		Lua = {}
	}
})

vim.lsp.config('clangd', {
	cmd = {
		'clangd',
		'--background-index',
		'--clang-tidy',
		'--completion-style=bundled',
		'--cross-file-rename',
		'--header-insertion=iwyu',
	},
})

vim.lsp.config('nil_ls', {
	settings = {
		['nil'] = {
			formatting = {
				command = { 'nixpkgs-fmt' },
			},
		},
	}
})

local lsp_servers = {
	'lua_ls',
	'clangd',
}

require('mason').setup({})
require('mason-lspconfig').setup({
	ensure_installed = lsp_servers,
	automatic_enable = true,
})
