# .zshrc

# Restrict write permissions.
umask 022


##
# Options. See zshoptions(1)

# Append history list to the history file
setopt inc_append_history
# Don't do menu completion
setopt no_auto_menu
# Show possible matches if completion can't figure out what to do.
setopt auto_list
# Treat single word simple commands without redirection
setopt auto_resume
# Puts more info in the history file
setopt extended_history
# Remove the history command from the history
setopt hist_no_store
# Remove superflous blanks from each command line
setopt hist_reduce_blanks
# Perform history expansion and reaload into editing buffer
setopt hist_verify
# Turns off C-S/C-Q flow control
setopt no_flow_control
# Sequential duplicate commands only get one history entry.
setopt hist_ignore_all_dups
# Send the HUP signal to running jobs when the shell exits
setopt hup
# Do completion on <value> in foo=<value>
setopt magic_equal_subst
# Don't error if globbing fails; just leave the globbing chars in.
setopt nonomatch
# Don't print a carriage return before the prompt.
setopt nopromptcr
# Don't bug me about it if I type 'rm *'.
setopt rm_star_silent


##
# Aliases.

# Enable aliases again.
unalias alias

# Preferred ls settings.
if [[ -x "`whence -p dircolors`" ]]; then
  eval `dircolors`
  alias ls='ls -aF --color=tty'
else
  alias ls='ls -aF'
fi

# Use vim instead of vi.
alias vi='vim'

##
# Parameters.  See zshparam(1)

# Extensions to ignore for completion.
FIGNORE=".o:.swp:~"
# Where to save my command history
HISTFILE=~/.zhistory
# Remember the last 5000 commands.
HISTSIZE=5000
# Only ask if completion listing would scroll off screen
LISTMAX=0
# Never look at my mail spool.
MAILCHECK=0
# Save the last 5000 commands.
SAVEHIST=5000


##
# ZLE settings.  See zshzle(1)

# Use vi-style bindings.
bindkey -v
bindkey -a "/" vi-history-search-forward
bindkey -a "?" vi-history-search-backward


##
# Other environment variables.

# Check for the existence of an SSH agent.
keychain --nocolor --quiet ~/.ssh/id_rsa 72679CAD
. ~/.keychain/`hostname`-sh
. ~/.keychain/`hostname`-sh-gpg

# Location of the mailbox.
case `hostname` in
  jrrr)
    export MAIL=~/mail/inbox
    ;;
esac

# So it's there.
export DISPLAY=":0.0"

# Preferred editor.
export EDITOR="vi"

# Preferred pager.
export PAGER="less"

# Temporary directory.
export TMPDIR="/tmp"

# Shell prompt.
export PROMPT="[%m] [%~]%% "

# added by travis gem
[ -f /home/cr3/.travis/travis.sh ] && source /home/cr3/.travis/travis.sh
