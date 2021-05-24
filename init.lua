vim.opt.number = true
vim.opt.undofile = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

vim.opt.guifont = "Courier New:h12"
vim.opt.clipboard = "unnamedplus"

vim.opt.completeopt = { "menu", "menuone", "noselect" }

require('packer').startup(function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'

	use 'arcticicestudio/nord-vim'
	use 'martinsione/darkplus.nvim'

	use 'tpope/vim-fugitive'
	use 'tpope/vim-dispatch'

	use 'nvim-treesitter/nvim-treesitter'

	use 'neovim/nvim-lspconfig'

	use 'hrsh7th/nvim-cmp'
	use 'hrsh7th/cmp-nvim-lsp'
	use 'hrsh7th/cmp-path'
	use 'hrsh7th/cmp-vsnip'
	use 'hrsh7th/vim-vsnip'
	use 'hrsh7th/cmp-nvim-lsp-signature-help'

	use 'simrat39/rust-tools.nvim'

	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.0',
		requires = {
			{ 'nvim-lua/plenary.nvim' }
		}
	}
	use {
		'nvim-telescope/telescope-fzf-native.nvim',
		run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
	}
end)

vim.cmd([[
	colorscheme darkplus
	"colorscheme nord
]])

require('nvim-treesitter.configs').setup {
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
}

require('telescope').load_extension('fzf')

-- bindings like https://helix-editor.com/
local function do_map_key(key, value)
	vim.keymap.set('n', key, value, {
		noremap = true,
		silent = true
	})
end
do_map_key('<leader>t', ":ClangdSwitchSourceHeader<cr>")

local fzf = require('telescope.builtin')
do_map_key('gd', fzf.lsp_definitions)
do_map_key('gD', vim.lsp.buf.declaration)
do_map_key('gi', fzf.lsp_implementations)
do_map_key('gr', fzf.lsp_references)
do_map_key('gy', vim.lsp.buf.type_definition)

do_map_key('<space>a', vim.lsp.buf.code_action)
do_map_key('<space>b', fzf.buffers)
do_map_key('<space>f', fzf.git_files)
do_map_key('<space>g', fzf.diagnostics)
do_map_key('<space>k', vim.lsp.buf.hover)
do_map_key('<space>r', vim.lsp.buf.rename)
do_map_key('<space>s', fzf.lsp_document_symbols)
do_map_key('<space>S', fzf.lsp_dynamic_workspace_symbols)

local cmp = require'cmp'
cmp.setup{
	snippet = {
      expand = function(args)
		  vim.fn["vsnip#anonymous"](args.body)
	  end,
    },
	sources =  {
		{ name = 'nvim_lsp' },
		{ name = 'path' },
		{ name = 'nvim_lsp_signature_help' }
	},
	mapping = cmp.mapping.preset.insert({
		['<CR>'] = cmp.mapping.confirm({ select = true }),
		['<Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif vim.fn["vsnip#available"](1) == 1 then
				feedkey('<Plug>(vsnip-expand-or-jump)', '')
			elseif has_words_before() then
				cmp.complete()
			else
				-- The fallback function sends a already mapped key. In this
				-- case, it's probably `<Tab>`.
				fallback()
			end
		end, {'i', 's'}),
		['<S-Tab>'] = cmp.mapping(function()
			if cmp.visible() then
				cmp.select_prev_item()
			elseif vim.fn['vsnip#jumpable'](-1) == 1 then
				feedkey('<Plug>(vsnip-jump-prev)', '')
			end
		end, {'i', 's'}),
	})
}

-- setup language servers
local capabilities = require('cmp_nvim_lsp').default_capabilities()
require'lspconfig'['clangd'].setup({
	capabilities = capabilities,
})
require'rust-tools'.setup({
	server = {
		capabilities = capabilities,
		on_attach = function(_, bufnr)
			vim.api.nvim_buf_set_option(bufnr, 'formatexpr', 'v:lua.vim.lsp.formatexpr()')
			vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
			vim.api.nvim_buf_set_option(bufnr, 'tagfunc', 'v:lua.vim.lsp.tagfunc')
		end
	}
})
