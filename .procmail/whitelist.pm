# .procmail/whitelist.pm

INCLUDERC="${HOME}/.procmail/variables.pm"

## Maintain whitelist

:0 Wh: $WHITELIST$LOCKEXT
| $FORMAIL -c -xTo: -xCc: -xBcc: \
| $TR ',' '\n' \
| $SED -e "s/^.*[^A-Za-z0-9_.+-]\([A-Za-z0-9_.+-]*@\)/\1/" \
  -e "s/\(@[A-Za-z0-9_.+-]*\)[^A-Za-z0-9_.+-].*$/\1/" \
| $SORT -fu -o $WHITELIST $WHITELIST -
