let s:first_rtp=split(&rtp, ",")[0]
function s:init_backup_undo()
	for s:d in ["undo", "backup"]
		if !isdirectory(s:d)
			call mkdir(s:first_rtp . "/" . s:d, "p")
		endif
	endfor
	exec 'set backupdir=' . s:first_rtp . '/backup'
	exec 'set undodir=' . s:first_rtp . '/undo'
	set undofile
endfunction
call s:init_backup_undo()

set number
set tabstop=4
set shiftwidth=4

set mouse=a
runtime! ftplugin/man.vim
colorscheme desert
set background=dark

if has('gui_running')
	if has('win32')
		set guifont=Courier\ New:h12
	else
		set guifont=Courier\ New\ 12
	endif
endif

call plug#begin(s:first_rtp . '/plugged')
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

" roughly mimic https://helix-editor.com/
nnoremap <silent> <space>b :Buffers<cr>
nnoremap <silent> <space>f :GitFiles<cr>
nnoremap <silent> <space>F :Files<cr>

" avoid ugly inline highlights
let g:lsp_diagnostics_highlights_enabled = 0
let g:lsp_diagnostics_virtual_text_enabled = 0

function! s:on_lsp_buffer_enabled() abort
	setlocal omnifunc=lsp#complete
	if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif

	nnoremap <buffer> [g <plug>(lsp-previous-reference)
	nnoremap <buffer> ]g <plug>(lsp-next-reference)

	nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
	nnoremap <buffer> <expr><c-d> lsp#scroll(-4)

	nnoremap <leader>t <plug>(lsp-switch-source-header)

	nnoremap <buffer> gd <plug>(lsp-definition)
	nnoremap <buffer> gD <plug>(lsp-declaration)
	nnoremap <buffer> gr <plug>(lsp-references)
	nnoremap <buffer> gi <plug>(lsp-implementation)
	nnoremap <buffer> gy <plug>(lsp-type-definition)

	nnoremap <buffer> <silent> <space>a :LspCodeAction<cr>
	nnoremap <buffer> <space>s <plug>(lsp-document-symbol-search)
	nnoremap <buffer> <space>S <plug>(lsp-workspace-symbol-search)
	nnoremap <buffer> <space>g <plug>(lsp-document-diagnostics)
	nnoremap <buffer> <space>k <plug>(lsp-hover)
	nnoremap <buffer> <space>r <plug>(lsp-rename)
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
