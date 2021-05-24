set number
set tabstop=4
set shiftwidth=4

runtime! ftplugin/man.vim

colorscheme desert

for s:d in ["undo", "backup"]
	if !isdirectory(s:d)
		call mkdir($HOME .. "/.vim/" .. s:d, "p")
	endif
endfor
set backupdir=~/.vim/backup
set undodir=~/.vim/undo
set undofile

set mouse=a
set guifont=Courier\ New:h12

call plug#begin('~/.vim/plugged')
	Plug 'tpope/vim-fugitive', {'tag': 'v3.3'}
	Plug 'tpope/vim-dispatch', {'tag': 'v1.8'}

	Plug 'will133/vim-dirdiff'

	Plug 'liuchengxu/vim-clap'
	Plug 'junegunn/fzf'
	Plug 'junegunn/fzf.vim'

	Plug 'prabirshrestha/vim-lsp'
	Plug 'mattn/vim-lsp-settings'

	Plug 'prabirshrestha/asyncomplete.vim'
	Plug 'prabirshrestha/asyncomplete-lsp.vim'
call plug#end()

" bindings like https://helix-editor.com/
nmap <silent> <leader>t :LspDocumentSwitchSourceHeader<cr>

nmap <silent> gd :LspDefinition<cr>
nmap <silent> gD :LspDeclaration<cr>
nmap <silent> gr :LspReferences<cr>

nmap <silent> <space>S :LspWorkspaceSymbol<cr>
nmap <silent> <space>a :LspCodeAction<cr>
nmap <silent> <space>b :Buffers<cr>
nmap <silent> <space>f :GitFiles<cr>
nmap <silent> <space>g :LspDocumentDiagnostics<cr>
nmap <silent> <space>k :LspHover<cr>
nmap <silent> <space>r :LspRename<cr>
nmap <silent> <space>s :LspDocumentSymbol<cr>
