# .zshenv

# Prevent /etc/z* files from setting aliases.
alias alias=:

##
# Locale variables
export LANG=C.UTF-8
export XTERM_LOCALE=C.UTF-8
export LC_CTYPE=C.UTF-8

##
# Environment variables.
export PATH="${HOME}/sbin:${HOME}/bin:/home/dev/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/bin/X11"
export FPATH="${HOME}/.zsh/functions:${FPATH}"
export HOST

##
# Library variables.
export LD_LIBRARY_PATH="${HOME}/lib:/usr/local/lib"
export PERL5LIB="${HOME}/lib/perl"
export PYTHONPATH="${HOME}/lib/python"

##
# Pyenv variables.
export PYENV_ROOT=/home/dev/src/pyenv
export PATH=$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH
eval "$(pyenv init -)"

##
# Python variables
if [[ -n $VIRTUAL_ENV && -e "${VIRTUAL_ENV}/bin/activate" ]]; then
  . "${VIRTUAL_ENV}/bin/activate"
fi

##
# AWS variables.
. ${HOME}/.zsh/aws.zsh

case $TERM in
  screen*)
    export TERM="xterm"
    ;;
esac
