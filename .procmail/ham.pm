# .procmailrc/ham.pm

INCLUDERC="${HOME}/.procmail/variables.pm"

# Message might not have a "From " line.
:0 fhw
| $FORMAIL

:0 fw
| $SPAMASSASSIN -d

:0 c
${MAILDIR}/ham

:0
inbox
