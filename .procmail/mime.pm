MIME      = "no"
MIME_H_QP = "no"
MIME_B_QP = "no"

MIME_VER

:0
* ^Mime-Version: *\/[0-9.]+
{
  MIME        = "yes"
  MIME_VER    = $MATCH

  :0
  * ^Content-Type: +\/.*
  {
    MIME_TYPE = $MATCH
  }

  :0
  *$ ^Content-Transfer-Encoding:$s+\/.*
  {
    MIME_CTE = $MATCH

    :0
    * MIME_CTE ?? quoted-printable
    {
      MIME_H_QP = "yes"
    }
  }

  :0
  *$ B ?? ^Content-Transfer-Encoding:$s+quoted-printable
  {
    MIME_B_QP = "yes"
  }

  :0
  * boundary *= *\"\/[^\";]+
  {
      MIME_BOUNDARY = $MATCH
  }

  # Hm, the boundary string was not surrounded by double quotes.
  # Search this kind of boundary string then:
  # 
  #  Content-Type: multipart/mixed; boundary=9i9nmIyA2yEADZbW

  :0 E
  * boundary *= *\/[^\";]+
  {
    #   "    Don't mind this, a dummy double quote to help Emacs
    #        to end starting quote below. Otherwise syntax colour
    #        highlighting would go beserk.
    MIME_BOUNDARY = $MATCH
  }

  :0
  *! MIME_BOUNDARY ?? ^^^^
  {
    #   Count how many mime sections there are in the message.
    #   MIME_BOUNDARY_COUNT -1 = count of mime sections.
    :0
    *$ B ?? 1^1  $\MIME_BOUNDARY
    { }

    MIME_BOUNDARY_COUNT = $=
  }
}

:0
*  MIME_TYPE ?? ^^^^
{
  #   Suppose this and change type below if we get a hit

  MIME_TYPE = "application/ms-tnef"

  0
  * ^Content-Type:.*image/()\/(jpeg|tiff|png|gif|bmp)
  {
    MIME_TYPE = "image/$MATCH"
  }

  :0 E
  * ^X-Lotus-FromDomain:
  {
    MIME_TYPE = "application/octet-stream"
  }

  :0 E
  * ^X-Mailer: (Microsoft.*Express|mozilla)
  {
    MIME_TYPE = "text/html"
  }

  :0 E
  * ^X-Mailer:.*mozilla
  * B ?? begin:.*vcard
  {
    MIME_TYPE = "text/x-vcard"
  }

  :0 E
  * B ?? application/x-openmail
  {
    MIME_TYPE = "application/x-openmail"
  }
}

MIME_KILL_RE = "name=.*(pcx|PCX)|charset=|This is.*MIME"
MIME_KILL2_RE = "Content-Type: +(text/html|application/ms-tnef|x-vcard)"

#   Prevent calling sh -c here. This speeds up procmail

SAVED_SHELLMETAS = $SHELLMETAS
modified             = "no"             # Flag
SHELLMETAS                              # kill variable

:0
* !     MIME_TYPE    ?? ^^^^
* !     MIME_BOUNDARY   ?? ^^^^
*  H ?? ^Content-Type:.*multipart
*$ B ?? ^Content-Type:$s+$MIME_TYPE
{
  #   If there were only 3 mime tags, then then message is in format
  #
  #       boundary-tag
  #        message
  #       boundary-tag
  #        unwanted-mime-part
  #       boundary-tag
  #
  #   a) make sure count is 3
  #   b) make sure we have the boundary string

  :0
  * MIME_BOUNDARY_COUNT   ?? ^^3^^
  {
    #   - AWK will kill the mime boundary strings, so we must remember
    #     if the message had quoted printable. The variable MIME_B_QP
    #     contain the qp information.
    #
    #   - Kill up till MIME type (eg. ms-tnef)
    #   - skip lines that match boundary string
    #   - Kill user defined lines
    #   - Kill MIME Content-XXXX headers from the body
    #
    #   We need the "i" flag because awk quits before it has read
    #   all the input

    dummy   = "$id: Killing all MIME"

    :0 fbw i
    | $AWK                                                              \
      ' {                                                               \
	  line = tolower($0);                                           \
	  if ( match(line, EXIT)      > 0 ) {exit}                      \
	  if ( match($0, RE)          > 0 ) {next}                      \
	  if ( match($0, KILL)        > 0 ) {next}                      \
	  if ( match($0, "^Content-") > 0 ) {next}                      \
	  print;                                                        \
	}                                                               \
      ' RE="$MIME_BOUNDARY"                                             \
	EXIT="$MIME_TYPE"                                               \
	KILL="$MIME_KILL_RE"

    #   -- If AWK succeeded --
    #   The body is no more  multipart/mixed. Correct headers or
    #   the MUA may get confused

    :0 a
    {
      #   Why Rewrite Mime-Version:
      #
      #   Lotus notes adds the boundary string to this header, but
      #   because we have already removed all boundary strings from the
      #   body, we must clear this header.
      #
      #   Call to replace Mime-Version header wipes the `boundary=` tag

      :0 fhw
      | $FORMAIL                                                      \
	-I "Content-Type: text/plain"                                 \
	-I "Mime-Version: $MIME_VER"                                  \
	-I "X-Mime-Type-Killed: $MIME_TYPE"

      modified = "yes"        # Yes, we changed body
    }
  }

  #   Note: 1997-12-30
  #
  #   - This works fine for ms-tnef, but it may be dangerous with
  #     Lotus notes, because it's attachment is a general
  #     "application/octec-stream".
  #   - Report me the problems if you encounter them with Lotus Notes.
  #

  #   There was more than 2 mime parts: just remove the base64 block.
  #
  #   - raise suppress flag if we find mime. Also change the mime type.
  #   - set flag back to 0 when the ending tag is found
  #   - print the lines when flag is 0
  #
  #   The ms-tnef is now converted to:
  #
  #       ------ NextPart_000_01BD04D4.A5AC6B00
  #       Content-Type: text/plain;
  #
  #       ------ NextPart_000_01BD04D4.A5AC6B00--
  #

  dummy = "$NL$NL$id: _not_ exactly 3 boundary strings"

  :0 fbw
  * ! MIME_BOUNDARY_COUNT ?? ^^3^^
  | $AWK                                                                  \
    ' {                                                                   \
	line = tolower($0);                                               \
	if ( match(line, HDR) > 0 )                                       \
	{                                                                 \
	     flag = 1; print "Content-Type: text/plain;"                  \
	}                                                                 \
	if ( match($0, RE) ) { flag = 0 }                                 \
	if ( flag == 0 )     { print    }                                 \
      }                                                                   \
    ' RE="$MIME_BOUNDARY" HDR="$MIME_TYPE"
}

#   Non-mime compliant messages
#
#   The only way to kill attachment is to use approximation.
#   If we do not have the boundary string (i.e. this not mime),
#   then apply this recipe.

:0
*        MIME_BOUNDARY    ?? ^^^^
*        MIME_KILL2_RE ?? [a-z]
*$ B ?? $MIME_KILL2_RE
{

  #   Well we could use SED here, but then there is a problem with
  #   "/" delimiter in sed. The awk solution accepts REGEXP as is
  #   as you don't have to play with funny quoting
  #
  #       sed -e "'"/$regexp/q"'"
  #
  #   or something like that... (the above is untested)

  :0 fbw
  | $AWK                                                                  \
    ' {                                                                   \
	if ( match($0,RE) > 0 )  {exit}                                   \
	print                                                             \
      }                                                                   \
    ' RE="$MIME_KILL2_RE"

  :0 A
  {
    :0 fhw
    | $FORMAIL -I "X-Mime-Type-Killed: Forced kill by MIME_KILL2_RE"

    modified = "yes"
  }
}

# ............................................................... &qp ...
#   Run conversion if it was quoted printable.
#   Also reflect correct MIME header

:0 fbw
*   modified        ?? yes
*   MIME_B_QP       ?? yes
*   MIME_BIN_QP     ?? [a-z]
|   $MIME_BIN_QP

:0 A fhw
| $FORMAIL -I "Content-Transfer-Encoding: 8bit"

SHELLMETAS  = $SAVED_SHELLMETAS
