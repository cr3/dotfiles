set wildignore+=*/venv/*

" pip install python-language-server
let g:ale_linters = {'python': ['flake8', 'pyls']}
let g:ale_python_flake8_change_directory = 0
let g:ale_virtualenv_dir_names = ['.tox/lint']

" supertab
let g:SuperTabDefaultCompletionType = "<c-x><c-o>"

" viminspect
let g:vimspector_install_gadgets = [ 'debugpy', 'vscode-python' ]
