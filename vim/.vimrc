map <space> <leader>

" necessary for lots of cool stuff
set nocompatible

call plug#begin('~/.vim/plugged')
Plug 'w0rp/ale'
Plug 'itchyny/lightline.vim'
Plug 'airblade/vim-gitgutter'
Plug 'digitaltoad/vim-pug'
call plug#end()

let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'
let g:ale_sign_column_always = 1
let g:ale_set_highlights = 0
highlight ALEErrorSign ctermbg=NONE ctermfg=red
highlight ALEWarningSign ctermbg=NONE ctermfg=yellow
let g:ale_fixers = { 'javascript': ['eslint'] }
let g:ale_fix_on_save = 1

highlight clear SignColumn
highlight SignColumn ctermbg=black
highlight GitGutterAdd ctermfg=green
highlight GitGutterChange ctermfg=yellow
highlight GitGutterDelete ctermfg=red
highlight GitGutterChangeDelete ctermfg=yellow

set runtimepath^=~/.vim/bundle/ctrlp.vim

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
inoremap <C-j> <esc>
inoremap <C-k> <esc>

" ; as : (useful when missing shift)
nnoremap ; :

" jump to start and end of line using the home row keys
map H ^
map L $

" shorter split navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
" ctrl-p settings
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_custom_ignore = '\v[\/](node_modules|target|dist|build)|(\.(swp|ico|git|svn))$'
let g:ctrlp_working_path_mode = 'ra'

map <C-k> <C-w>k
map <C-l> <C-w>l

" german characters
imap :a ä
imap :u ü
imap :o ö
imap :A Ä
imap :U Ü
imap :O Ö
imap :s ß

" leader shortcuts
map <leader>w :w<CR>
map <leader>s :set spell!<CR>
map <leader>n :set number!<CR>:set relativenumber!<CR>
map <leader>b :w! \| ./build.sh<CR>
map <leader>g mygqip`y
map <leader>d i<C-R>=strftime('%A (%F)')<CR><esc>
map <leader>x my0vlll:s/\[ \]/[x]/<CR>`y
map <leader>X my0vlll:s/\[x\]/[ ]/<CR>`y
map <leader>ne gg?^E\d\d\d\d\d<CR>yw}o<esc>p<C-A>A <C-R>=strftime('%y.%m.%d%H:%M:%S (%A)')<CR><esc>o<tab>

" some basics
syntax on

set tabstop=4
set shiftwidth=4
set background=dark

set number
set relativenumber
set smartindent
set encoding=utf-8
set printencoding=utf-8

" sane splits
set splitright
set splitbelow

" allow multiple buffers without saving
set hidden

" use the current working directory and subfolders for searching
set path+=**

" shows you what you are typing as a command
set showcmd

" proper search
set incsearch  " highlight while searching
set ignorecase " case insensitive pattern matching
set smartcase  " override ignorecase if pattern contains uppercase
set gdefault   " replace global (///g) as default

" enable autocompletion
set wildmenu
set wildmode=longest,list,full

" set max width based on the file type
if has("autocmd")
        au BufRead,BufNewFile *.txt setlocal textwidth=80
endif

" delete trailing whitespace on save
autocmd BufWritePre * %s/\s\+$//e

" disable automatic comment insertion
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" remember cursor position
if has("autocmd")
        au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif

" reload vimrc after saving it
if has("autocmd")
        augroup reload_vimrc
                autocmd!
                autocmd! BufWritePost $MYVIMRC,$MYGVIMRC nested source %
        augroup END
endif
