" ale
" rustup component add rls-preview rust-analysis rust-src
let g:ale_linters = {'rust': ['rls']}

" omnifunc
set omnifunc=ale#completion#OmniFunc

" rustfmt
command! -buffer RustFmt call rustfmt#Format()
command! -range -buffer RustFmtRange call rustfmt#FormatRange(<line1>, <line2>)
augroup rust.vim.PreWrite
    autocmd!
    autocmd BufWritePre *.rs silent! call rustfmt#PreWrite()
augroup END

" supertab
let g:SuperTabDefaultCompletionType = "<c-x><c-o>"
