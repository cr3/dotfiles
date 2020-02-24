# .zshenv

# Prevent /etc/z* files from setting aliases.
alias alias=:

##
# Locale variables
export LANG=en_CA.UTF-8
export XTERM_LOCALE=en_CA.UTF-8
export LC_CTYPE=en_CA.UTF-8

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
# Stack variables
export STACK_LOCAL=$HOME/.local
export PATH=$STACK_LOCAL/bin:$PATH

##
# Pyenv variables.
export PYENV_ROOT=/home/dev/src/pyenv
export PATH=$PYENV_ROOT/bin:$PATH
eval "$(pyenv init -)"

##
# Python variables
if [[ -n $VIRTUAL_ENV && -e "${VIRTUAL_ENV}/bin/activate" ]]; then
  . "${VIRTUAL_ENV}/bin/activate"
fi

##
## Rust variables.
export CARGO_ROOT=$HOME/.cargo
export PATH=$CARGO_ROOT/bin:$PATH

##
# Maven variables.
export M2_HOME=/home/dev/src/apache-maven-3.3.9
export M2=$M2_HOME/bin
export MAVEN_OPTS="-Xms256m -Xmx512m"
export PATH=$M2:$PATH

##
# Firefox variables.
export FIREFOX_HOME=/home/dev/firefox
export PATH=$FIREFOX_HOME:$PATH

##
# AWS variables.
. ${HOME}/.zsh/aws.zsh

case $TERM in
  screen*)
    export TERM="xterm"
    ;;
esac
