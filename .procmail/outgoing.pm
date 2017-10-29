# .procmail/outgoing.pm

INCLUDERC="${HOME}/.procmail/variables.pm"

## Maintain whitelist

:0 c
{
  INCLUDERC="${PMDIR}/whitelist.pm"
}

## Default

:0
* ^From:.*[<]\/[^>]*
| $MSMTP -t -f $MATCH
