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

" Set shell to zsh for ~/.zsh* files
set shell=zsh

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

" Clear the search buffer when hitting return
nnoremap <CR> :nohlsearch<cr>

" Map \e and \v to open files in the same directory as the current file
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>e :edit %%
map <leader>v :view %%

" Command-T
map <leader>f :CommandTFlush<cr>\|:CommandT<cr>
map <leader>gf :CommandTFlush<cr>\|:CommandT %%<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RUNNING TESTS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! MapCR()
  nnoremap <cr> :call RunTestFile()<cr>
endfunction
call MapCR()
nnoremap <leader>T :call RunNearestTest()<cr>
nnoremap <leader>a :call RunTests('')<cr>

function! RunTestFile(...)
    if a:0
        let command_suffix = ""
    else
        let command_suffix = ""
    endif

    " Are we in a test file?
    let in_test_file = match(expand("%"), '\(_spec.rb\|_test.rb\|test_.*\.py\|_test.py\)$') != -1

    " Run the tests for the previously-marked file (or the current file if
    " it's a test).
    if in_test_file
        call SetTestFile(command_suffix)
    elseif !exists("t:grb_test_file")
        return
    end
    call RunTests(t:grb_test_file)
endfunction

function! RunNearestTest()
    let spec_line_number = line('.')
    call RunTestFile(":" . spec_line_number)
endfunction

function! SetTestFile(command_suffix)
    " Set the spec file that tests will be run for.
    let t:grb_test_file=@% . a:command_suffix
endfunction

function! RunTests(filename)
    " Write the file and run tests for the given filename
    if expand("%") != ""
      :w
    end
    " The file is executable; assume we should run
    if executable(a:filename)
      exec ":!./" . a:filename
    " Project-specific test script
    elseif filereadable("script/test")
        exec ":!script/test " . a:filename
    " Fall back to the .test-commands pipe if available, assuming someone
    " is reading the other side and running the commands
    elseif filewritable(".test-commands")
      let cmd = 'rspec --color --format progress --require "~/lib/vim_rspec_formatter" --format VimFormatter --out tmp/quickfix'
      exec ":!echo " . cmd . " " . a:filename . " > .test-commands"

      " Write an empty string to block until the command completes
      sleep 100m " milliseconds
      :!echo > .test-commands
      redraw!
    " Fall back to a blocking test run with Bundler
    elseif filereadable("bin/rspec")
      exec ":!bin/rspec --color " . a:filename
    elseif filereadable("Gemfile") && strlen(glob("spec/**/*.rb"))
      exec ":!bundle exec rspec --color " . a:filename
    elseif filereadable("Gemfile") && strlen(glob("test/**/*.rb"))
      exec ":!bin/rails test " . a:filename
    " If we see python-looking tests, assume they should be run with py.test
    elseif strlen(glob("test/**/*.py") . glob("tests/**/*.py"))
      if strlen(a:filename)
        exec "!py.test -s -v " . a:filename
      elseif strlen(glob("test/**/*.py"))
        exec "!py.test -s -v test"
      elseif strlen(glob("tests/**/*.py"))
        exec "!py.test -s -v tests"
      end
    end
endfunction
