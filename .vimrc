" .vimrc

" Remove all existing autocmds
autocmd!

" Pathogen
execute pathogen#infect()

" Use vim defaults.
set nocompatible

" Automatically set the indent of a newline.
set autoindent

" Number of lines remembered.
set history=1000

" Pairs that match the "%" command.
set matchpairs+=<:>

" No window title.
set notitle

" Show cursor potition.
set ruler

" Encoding
set encoding=utf-8

" Round indent to multiple of 'shiftwidth'
set shiftround

" Briefly jump to matching bracket.
set showmatch

" Insert only one space when joining lines that contain sentence-terminating
" punctuation like `.`.
set nojoinspaces

" Enable highlighting when the terminal has colors.
if &t_Co > 2 || has("gui_running")
  " Highlight syntax.
  syntax on

  " Highlight search pattern.
  set hlsearch
endif

" Remap Ctrl-x, Ctrl-o
inoremap <Nul> <C-x><C-o>

" Show pattern as it is typed.
"set incsearch
set wim=longest,list

"set list
"set listchars=tab:>.,trail:-
"match Error /\%>79v.\+/

" Enable plugins
filetype plugin on

" TeX configuration
let g:Tex_AutoFolding = 0
let g:Tex_UseMakefile = 0

" Remap <leader> from / to ,
let mapleader=","

" Map \e and \v to open files in the same directory as the current file
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>e :edit %%
map <leader>v :view %%

" Command-T
map <leader>f :CommandTFlush<cr>\|:CommandT<cr>
map <leader>gf :CommandTFlush<cr>\|:CommandT %%<cr>
