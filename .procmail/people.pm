# .procmail/people.pm

## Filter mailboxes.

:0
* PEOPLE ?? !^$
{
  PERSON = `echo "$PEOPLE" | sed 's/,.*//'`
  PEOPLE = `echo "$PEOPLE" | sed 's/[^,]*,//'`

  # For reading.
  :0
  | echo $PERSON >> /tmp/a

  INCLUDERC="${HOME}/.procmail/people.pm"
}
