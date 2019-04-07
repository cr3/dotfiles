set wildignore+=*/venv/*

let b:ale_linters = ['flake8']
call ale#Set('python_flake8_executable', '.tox/lint/bin/flake8')
