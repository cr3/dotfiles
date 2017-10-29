# .procmail/variables.pm

PATH		= "${HOME}/bin:/bin:/usr/bin:/usr/local/bin"
MAILDIR		= "${HOME}/mail"
PMDIR		= "${HOME}/.procmail"

LOCKEXT		= ".lock"

## Buffering
LINEBUF		= 4096

## Programs
CAT		= ${CAT:-"/bin/cat"}
SED		= ${SED:-"/bin/sed"}

AWK		= ${AWK:-"awk"}
FGREP		= ${FGREP:-"fgrep"}
SORT		= ${SORT:-"sort"}
TR		= ${TR:-"tr"}

FORMAIL		= ${FORMAIL:-"formail"}
PROCMAIL	= ${PROCMAIL:-"procmail"}

SPAMASSASSIN	= ${SPAMASSASSIN:-"spamassassin"}
SPAMC		= ${SPAMC:-"spamc"}

MSMTP		= ${MSMTP:-"msmtp"}

## Emails
BLACKLIST	= "${PMDIR}/blacklist"
WHITELIST	= "${PMDIR}/whitelist"
