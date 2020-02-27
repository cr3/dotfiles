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

" Pairs that match the '%' command.
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

" Set shell to zsh for ~/.zsh* files
set shell=zsh

" Set tags from git hooks
set tags=.git/tags

" Enable highlighting when the terminal has colors.
if &t_Co > 2 || has('gui_running')
  " Highlight syntax.
  syntax on

  " Highlight search pattern.
  set hlsearch
endif

" Remap Ctrl-x, Ctrl-o
inoremap <Nul> <C-x><C-o>

" Show pattern as it is typed.
"set incsearch
set wildmode=longest,list

"set list
"set listchars=tab:>.,trail:-
"match Error /\%>79v.\+/

" Enable plugins
filetype plugin on

" Remap <leader> from / to ,
let g:mapleader=','

" Clear the search buffer when hitting return
nnoremap <CR> :nohlsearch<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CUSTOM AUTOCMDS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup vimrcEx
  " Clear all autocmds in the group
  autocmd!

  autocmd FileType cabal,haskell set sw=2 sts=2 expandtab
  autocmd FileType javascript set sw=2 sts=2 autoindent expandtab nocindent smartindent
  autocmd FileType java set sw=4 sts=4 expandtab
  autocmd FileType python set sw=4 sts=4 expandtab
  autocmd FileType text setlocal textwidth=78
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MISC KEY MAPS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Move around splits with <c-hjkl>
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" Edit the alternatve file with <leader><leader>
nnoremap <leader><leader> <c-^>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" FILE NAVIGATION
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Map \e and \v to open files in the same directory as the current file
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>e :edit %%
map <leader>v :view %%

" ctrlp
map <leader>f :CtrlP<cr>
map <leader>. :CtrlPTag<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RUNNING TESTS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <leader>t :call RunNearestTest()<cr>
nnoremap <leader>T :call RunTests('')<cr>

function! RunTestFile(...)
    " Are we in a test file?
    let l:hs_test_file = match(expand('%'), '\(Spec\.hs\|.*Tests\.hs\)$') != -1
    let l:py_test_file = match(expand('%'), '\(test_.*\.py\|_test\.py\)$') != -1
    let l:rs_test_file = match(expand('%'), '.*\.rs$') != -1

    " Run the tests for the previously-marked file (or the current file if
    " it's a test).
    if l:hs_test_file
        call SetTestFile('')
    elseif l:py_test_file
        call SetTestFile('')
    elseif l:rs_test_file
        call SetTestFile('')
    elseif !exists('t:grb_test_file')
        return
    end
    call RunTests(t:grb_test_file)
endfunction

function! RunNearestTest()
    let l:spec_line_number = line('.')
    call RunTestFile(':' . l:spec_line_number)
endfunction

function! SetTestFile(command_suffix)
    " Set the spec file that tests will be run for.
    let t:grb_test_file=@% . a:command_suffix
endfunction

function! RunTests(filename)
    " Write the file and run tests for the given filename
    if expand('%') !=? ''
      :w
    end
    " The file is executable; assume we should run
    if executable(a:filename)
      exec '!./' . a:filename
    " If we see haskell-looking tests, assume they should be run with stack.
    elseif strlen(glob('**/*Spec.hs') . glob('**/*Tests.hs'))
      :!stack test
    " If we see rust-looking tests, assume they should be run with cargo.
    elseif strlen(glob('**/*.rs'))
      :!cargo test
    " If we see python-looking tests, assume they should be run with tox.
    elseif strlen(glob('test/**/*.py') . glob('tests/**/*.py'))
      if strlen(a:filename)
        exec '!tox -- -s -v ' . a:filename
      elseif strlen(glob('test/**/*.py'))
        :!tox -- -s -v test
      else  " strlen(glob('tests/**/*.py'))
        :!tox -- -s -v tests
      end
    end
endfunction

let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0
