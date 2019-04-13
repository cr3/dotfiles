" ale
let b:ale_linters = ['ghc-mod', 'hlint', 'stack-ghc']
call ale#Set('haskell_ghc_mod_executable', 'stack exec ghc-mod')
call ale#Set('haskell_stack_ghc_options', '-Wall -fno-code -v0')

" ctrlp
let g:ctrlp_custom_ignore = '\v[\/](dist|dist-newstyle)$'

" tabular
let g:haskell_tabular = 1

vmap a= :Tabularize /=<CR>
vmap a; :Tabularize /::<CR>
vmap a- :Tabularize /-><CR>

" supertab
inoremap <Nul> <c-r>=SuperTabAlternateCompletion("\<lt>c-x>\<lt>c-o>")<cr>

" neco-ghc
let g:haskellmode_completion_ghc = 1
autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

" ghcmod
map <silent> tw :GhcModTypeInsert<CR>
map <silent> ts :GhcModSplitFunCase<CR>
map <silent> tq :GhcModType<CR>
map <silent> te :GhcModTypeClear<CR>
