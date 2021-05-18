runtime! vimrc_example.vim
runtime! ftplugin/man.vim
runtime! fugitive.vim

set noswapfile
set backupdir=~/.vim/backup
set undodir=~/.vim/undo

set number
set tabstop=4
set shiftwidth=4

"colorscheme elflord
"colorscheme desert
"colorscheme darkblue

set mouse=n

nmap <F7>   :cn<ENTER>
nmap <S-F7> :cp<ENTER>

set tags+=~/.vim/tags
"set tags+=~/azure-c-shared-utility/tags
set tags+=~/azure-uamqp-c/tags

function ToggleSourceHeader()
	if expand("%:e") == "cpp"
		exe ":e %:p:.:r.h"
	elseif expand("%:e") == "h"
		exe ":e %:p:.:r.cpp"
	endif
endfunc
nmap <leader>t :call ToggleSourceHeader()<ENTER>

set guifont=Courier\ Prime\ 13
"set guifont=FreeMono\ 14

call plug#begin('~/.vim/plugged')
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

runtime! coc.vim
packadd! matchit
