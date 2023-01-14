" Author: Marc Tardif <marc@interunion.ca>

let s:CindentLog = $HOME.'/.indent.log'
let s:CindentSavedOptions = {}

function! s:CindentSaveOption ( option, ... )
  exe 'let escaped =&'.a:option
  if a:0 == 0
    let escaped = escape( escaped, ' |"\' )
  else
    let escaped = escape( escaped, ' |"\'.a:1 )
  endif
  let s:CindentSavedOptions[a:option] = escaped
endfunction

function! s:CindentRestoreOption ( option )
  exe ':set '.a:option.'='.s:CindentSavedOptions[a:option]
endfunction

function! cindent#Indent ( )
  let l:currentbuffer = expand('%:p')
  :update
  exe ':cclose'
  silent exe ':%!indent 2> '.s:CindentLog
  redraw!
  call s:CindentSaveOption('errorformat')
  if getfsize( s:CindentLog ) > 0
    exe ':edit! '.s:CindentLog
    let logbuffer  = bufnr('%')
    exe ':%s/^indent: Standard input/indent: '.escape( l:currentbuffer, '/' ).'/'
    setlocal errorformat=indent:\ %f:%l:%m
    :cbuffer
    exe ':bdelete! '.logbuffer
    exe ':botright cwindow'
  else
    echomsg 'File "'.l:currentbuffer.'" reformatted.'
  endif
  call s:CindentRestoreOption('errorformat')
endfunction
