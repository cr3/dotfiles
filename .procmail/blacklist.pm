# .procmail/blacklist.pm

INCLUDERC       = "${HOME}/.procmail/variables.pm"

# Maintain blacklist.

:0 Wh: $BLACKLIST$LOCKEXT
| $FORMAIL -xFrom: \
| $SED -e "s/^.*[^A-Za-z0-9_.+-]\([A-Za-z0-9_.+-]*@\)/\1/" \
  -e "s/\(@[A-Za-z0-9_.+-]*\)[^A-Za-z0-9_.+-].*$/\1/" \
| $SORT -fu -o $BLACKLIST $BLACKLIST -
