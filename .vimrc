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

" Use the new SnipMate parser
let g:snipMate = { 'snippet_version' : 1 }

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CUSTOM AUTOCMDS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup vimrcEx
  " Clear all autocmds in the group
  autocmd!

  autocmd FileType javascript set sw=2 ts=2 autoindent noexpandtab nocindent smartindent
  autocmd FileType python set sw=4 sts=4 expandtab omnifunc=ale#completion#OmniFunc
  autocmd FileType text setlocal textwidth=78
  autocmd FileType typescript set sw=2 ts=2 autoindent noexpandtab nocindent smartindent
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
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" DEBUGGING
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <Leader>dd :call vimspector#Launch()<CR>
nnoremap <Leader>de :call vimspector#Reset()<CR>
nnoremap <Leader>dc :call vimspector#Continue()<CR>

nnoremap <Leader>dt :call vimspector#ToggleBreakpoint()<CR>
nnoremap <Leader>dT :call vimspector#ClearBreakpoints()<CR>

nmap <Leader>dl <Plug>VimspectorStepInto
nmap <Leader>dj <Plug>VimspectorStepOver
nmap <Leader>dh <Plug>VimspectorStepOut
nmap <Leader>dk <Plug>VimspectorRestart

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TESTING
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <leader>t :call RunNearestTest()<cr>
nnoremap <leader>T :call RunTests('')<cr>

function! RunTestFile(...)
    " Are we in a test file?
    let l:hs_test_file = match(expand('%'), '\(Spec\.hs\|.*Tests\.hs\)$') != -1
    let l:js_test_file = match(expand('%'), '.*\(spec\|test\)\.\(js\|ts\|tsx\)$') != -1
    let l:py_test_file = match(expand('%'), '\(test_.*\.py\|_test\.py\)$') != -1
    let l:rs_test_file = match(expand('%'), '.*\.rs$') != -1

    " Run the tests for the previously-marked file (or the current file if
    " it's a test).
    if l:hs_test_file
        call SetTestFile('')
    elseif l:js_test_file
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
    " If we see js- or ts-looking tests, assume they should be run with npm.
    elseif strlen(glob('**/*test.js') . glob('**/*test.ts') . glob('**/*spec.tsx'))
      if strlen(a:filename)
        exec '!npm test ' . a:filename
      else
        :!npm test
      end
    " If we see python-looking tests, assume they should be run with tox.
    elseif strlen(glob('**/test_*.py') . glob('test/**/*.py') . glob('tests/**/*.py'))
      if strlen(a:filename)
	" exec '!python -m pytest ' . a:filename
        exec '!tox -- -s -v ' . a:filename
      elseif strlen(glob('test/**/*.py'))
        :!tox -- -s -v test
      else  " strlen(glob('tests/**/*.py'))
        :!tox -- -s -v tests
      end
    " If we see rust-looking tests, assume they should be run with cargo.
    elseif strlen(glob('**/*.rs'))
      :!cargo test
    end
endfunction
