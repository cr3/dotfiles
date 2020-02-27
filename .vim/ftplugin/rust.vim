" ale
" rustup component add rls-preview rust-analysis rust-src
let g:ale_linters = {'rust': ['rls']}

" supertab
let g:SuperTabDefaultCompletionType = "<c-n>"

" rustfmt
command! -buffer RustFmt call rustfmt#Format()
command! -range -buffer RustFmtRange call rustfmt#FormatRange(<line1>, <line2>)
augroup rust.vim.PreWrite
    autocmd!
    autocmd BufWritePre *.rs silent! call rustfmt#PreWrite()
augroup END
