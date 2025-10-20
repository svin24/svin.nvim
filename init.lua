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
-- Space as leader key
vim.g.mapleader = ' '

-- Basic clipboard interaction
vim.keymap.set({ 'n', 'x' }, 'gy', '"+y', { desc = 'Copy to clipboard' })
vim.keymap.set({ 'n', 'x' }, 'gp', '"+p', { desc = 'Paste clipboard content' })

-- ========================================================================== --
-- ==                               PLUGINS                                == --
-- ========================================================================== --

local mini = {}

mini.branch = 'main'
mini.packpath = vim.fn.stdpath('data') .. '/site'

function mini.require_deps()
	local uv = vim.uv or vim.loop
	local mini_path = mini.packpath .. '/pack/deps/start/mini.nvim'

	if not uv.fs_stat(mini_path) then
		print('Installing mini.nvim....')
		vim.fn.system({
			'git',
			'clone',
			'--filter=blob:none',
			'https://github.com/nvim-mini/mini.nvim',
			string.format('--branch=%s', mini.branch),
			mini_path
		})

		vim.cmd('packadd mini.nvim | helptags ALL')
	end

	local ok, deps = pcall(require, 'mini.deps')
	if not ok then
		return {}
	end

	return deps
end

local MiniDeps = mini.require_deps()
if not MiniDeps.setup then
	return
end

-- See :help MiniDeps.config
MiniDeps.setup({
	path = {
		package = mini.packpath,
	},
})

-- MiniDeps.add('svin24/accent.nvim')
MiniDeps.add('folke/which-key.nvim')
MiniDeps.add({
	source = 'nvim-mini/mini.nvim',
	checkout = mini.branch,
})

MiniDeps.add('neovim/nvim-lspconfig')
MiniDeps.add({
	source = 'nvim-treesitter/nvim-treesitter',
	checkout = 'main',
	hooks = {
		post_checkout = function()
			vim.cmd.TSUpdate()
		end,
	},
})

-- ========================================================================== --
-- ==                         PLUGIN CONFIGURATION                         == --
-- ========================================================================== --

-- Personal theme
-- require('accent').setup({
-- 	accent_color = 'orange',
-- 	accent_darken = false,
-- 	invert_status = false,
-- 	auto_cwd_color = false,
-- 	no_bg = true,
-- })
vim.cmd.colorscheme('miniautumn')

-- See :help MiniIcons.config
-- Change style to 'glyph' if you have a font with fancy icons
require('mini.icons').setup({ style = 'ascii' })

-- See :help MiniAi-textobject-builtin
require('mini.ai').setup({ n_lines = 500 })

-- See :help MiniComment.config
require('mini.comment').setup({})

-- See :help MiniSurround.config
require('mini.surround').setup({})

-- See :help MiniNotify.config
require('mini.notify').setup({
	lsp_progress = { enable = false },
})

-- See :help MiniBufremove.config
require('mini.bufremove').setup({})

-- Close buffer and preserve window layout
vim.keymap.set('n', '<leader>bc', '<cmd>lua pcall(MiniBufremove.delete)<cr>', { desc = 'Close buffer' })

-- See :help MiniFiles.config
local mini_files = require('mini.files')
mini_files.setup({})

-- Toggle file explorer
-- See :help MiniFiles-navigation
vim.keymap.set('n', '<leader>e', function()
	if mini_files.close() then
		return
	end

	mini_files.open()
end, { desc = 'File explorer' })

-- See :help MiniPick.config
require('mini.pick').setup({})

-- See available pickers
-- :help MiniPick.builtin
-- :help MiniExtra.pickers
vim.keymap.set('n', '<leader>?', '<cmd>Pick oldfiles<cr>', { desc = 'Search file history' })
vim.keymap.set('n', '<leader><space>', '<cmd>Pick buffers<cr>', { desc = 'Search open files' })
vim.keymap.set('n', '<leader>ff', '<cmd>Pick files<cr>', { desc = 'Search all files' })
vim.keymap.set('n', '<leader>fg', '<cmd>Pick grep_live<cr>', { desc = 'Search in project' })
vim.keymap.set('n', '<leader>fd', '<cmd>Pick diagnostic<cr>', { desc = 'Search diagnostics' })
vim.keymap.set('n', '<leader>fs', '<cmd>Pick buf_lines<cr>', { desc = 'Buffer local search' })

-- See :help MiniStatusline.config
require('mini.statusline').setup({})

-- See :help MiniExtra
require('mini.extra').setup({})

-- See :help MiniSnippets.config
require('mini.snippets').setup({})

-- See :help MiniCompletion.config
require('mini.completion').setup({})

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
})

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
	end,
})

-- Auto-format on save

vim.api.nvim_create_autocmd('BufWritePre', {
	callback = function(event)
		-- Check if there's an LSP client attached
		local clients = vim.lsp.get_clients({ bufnr = event.buf })
		if #clients > 0 then
			vim.lsp.buf.format({ async = false, bufnr = event.buf })
		end
	end,
})

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

vim.lsp.enable('nil_ls')
vim.lsp.enable('lua_ls')
vim.lsp.enable('clangd')
vim.lsp.enable('gopls')
vim.lsp.enable('intelephense')
vim.lsp.enable('rust_analyzer')
vim.lsp.enable('denols')
vim.lsp.enable('basedpyright')
