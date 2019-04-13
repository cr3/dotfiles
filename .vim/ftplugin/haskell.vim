" ale
let b:ale_linters = ['ghc-mod', 'hlint', 'stack-ghc']
call ale#Set('haskell_ghc_mod_executable', 'stack exec ghc-mod')
call ale#Set('haskell_stack_ghc_options', '-Wall -fno-code -v0')

" ctrlp
let g:ctrlp_custom_ignore = '\v[\/](dist|dist-newstyle)$'
