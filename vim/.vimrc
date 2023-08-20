" the basics
set nocompatible
syntax enable
filetype plugin on

map <space> <leader>

set tabstop=4
set shiftwidth=4
set background=dark

set number
set relativenumber
set smartindent
set encoding=utf-8
set printencoding=utf-8

set showcmd " shows you what you are typing as a command
set hidden  " allow multiple buffers without saving

" sane splits
set splitright
set splitbelow

" use the current working directory and subfolders for searching
set path+=**

" proper search
set incsearch  " highlight while searching
set ignorecase " case insensitive pattern matching
set smartcase  " override ignorecase if pattern contains uppercase
set gdefault   " replace global (///g) as default

" enable autocompletion
set wildmenu
set wildmode=longest,list,full

" autocmd
if has("autocmd")
	" set max width based on the file type
	autocmd BufRead,BufNewFile *.txt setlocal textwidth=80

	" delete trailing whitespace on save
	autocmd BufWritePre * %s/\s\+$//e

	" disable automatic comment insertion
	autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

	" remember cursor position
	autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

	" reload vimrc after saving it
	augroup reload_vimrc
		autocmd!
		autocmd! BufWritePost $MYVIMRC,$MYGVIMRC nested source %
	augroup END
endif

" function to toggle imaps for German
let b:my_german_imaps = "off"

function! ToggleGermanIMaps()
	if b:my_german_imaps == "on"
		iunmap :a
		iunmap :u
		iunmap :o
		iunmap :A
		iunmap :U
		iunmap :O
		iunmap :s
		let b:my_german_imaps = "off"
		echo "German insert mappings disabled"
	else
		imap :a ä
		imap :u ü
		imap :o ö
		imap :A Ä
		imap :U Ü
		imap :O Ö
		imap :s ß
		let b:my_german_imaps = "on"
		echo "German insert mappings enabled"
	endif
endfunction

function! ToggleHeaderCodeFile()
	let ext = expand("%:e")
	if ext == "c"
		:e %<.h
	elseif ext == "h"
		:e %<.c
	endif
endfunction

" disable arrow keys (use home row!)
nnoremap <left>  :echoe "Use h"<CR>
nnoremap <right> :echoe "Use l"<CR>
nnoremap <up>    :echoe "Use k"<CR>
nnoremap <down>  :echoe "Use j"<CR>

" left and right can switch buffers
nnoremap <left>  :bp<CR>
nnoremap <right> :bn<CR>

" move by line (relevant when wrapping)
nnoremap j gj
nnoremap k gk

" map more ESC options
inoremap jk <esc>
inoremap kj <esc>
inoremap <C-j> <esc>
inoremap <C-k> <esc>

" ; as : (useful when missing shift)
nnoremap ; :

" jump to start and end of line using the home row keys
map H ^
map L $

" keep the cursor in the center while moving up and down
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" faster split navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" system clipboard integrations
vnoremap <leader>d "+d
vnoremap <leader>y "+y

nnoremap <leader>p "+p
nnoremap <leader>P "+P

" leader shortcuts
map <leader>w :w<CR>
map <leader>W :wa<CR>
map <leader>m :wa<CR>:make<CR>
map <leader>f :find<space>
map <leader>b :b<space>
  "map <leader>g m0:%s/  \+/ /e<CR>gg=G`0

" toggle various things (with <leader>t)
map <leader>ts :set spell!<CR>
map <leader>tn :set number!<CR>:set relativenumber!<CR>
map <leader>tg :call ToggleGermanIMaps()<CR>

map <leader>h :call ToggleHeaderCodeFile()<CR>
