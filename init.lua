-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },

			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end

vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- add your plugins here
		{
			"tpope/vim-fugitive",
		},
		{
			"nvim-telescope/telescope.nvim",
			tag = "v0.1.9",
			dependencies = { "nvim-lua/plenary.nvim" },
		},
		{
			"neovim/nvim-lspconfig",
		},
		{
			"github/copilot.vim",
			dependencies = { "CopilotC-Nvim/CopilotChat.nvim" },
		},
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release --target install",
		},
		{
			"nvim-treesitter/nvim-treesitter",
			lazy = false,
			branch = "main",
			build = ":TSUpdate",
		},
		{
			"shaunsingh/nord.nvim",
			"folke/tokyonight.nvim",
		},
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "habamax" } },
	-- automatically check for plugin updates
	checker = { enabled = true },
})

vim.opt.number = true
vim.opt.undofile = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

vim.opt.guifont = "Courier New:h12"
vim.opt.clipboard = "unnamedplus"
vim.opt.shellpipe = "2>&1| coreutils tee"

vim.cmd.colorscheme("habamax")

-- bindings like https://helix-editor.com/
local function do_map_key(key, value)
	vim.keymap.set("n", key, value, {
		noremap = true,
		silent = true,
	})
end
do_map_key("<leader>t", ":ClangdSwitchSourceHeader<cr>")

local fzf = require("telescope.builtin")
do_map_key("gd", fzf.lsp_definitions)
do_map_key("gD", vim.lsp.buf.declaration)
do_map_key("gi", fzf.lsp_implementations)
do_map_key("gr", fzf.lsp_references)
do_map_key("gy", fzf.lsp_type_definitions)

do_map_key("<space>a", vim.lsp.buf.code_action)
do_map_key("<space>b", fzf.buffers)
do_map_key("<space>f", fzf.git_files)
do_map_key("<space>F", fzf.find_files)
do_map_key("<space>g", fzf.diagnostics)
do_map_key("<space>k", vim.lsp.buf.hover)
do_map_key("<space>r", vim.lsp.buf.rename)
do_map_key("<space>s", fzf.lsp_document_symbols)
do_map_key("<space>S", fzf.lsp_dynamic_workspace_symbols)

vim.lsp.enable("clangd")
