use strict;
use Irssi 20020101.0250 ();
use vars qw($VERSION %IRSSI);
$VERSION = "0.1";

#
# bitlbee auto reconnect
# Copyright (c) 2004 Benoit Bourdin (bennyben)
#
# usage: 
#	connect to your bitlbee server,
#	identify using /bitlbee_ident <password> (NOT /msg #bitlbee identify <password> !)
#	and then after identification would be automatic.
#	Note: you can do /bitlbee_ident before connecting to server.
#
# Important:
#       You must set your server tag (like in /ircnet) to a name that
#	matches bitlbee_servertag_regexp.
#
#	By default, you can do :
#	/ircnet add bitlbee
#	/server add -ircnet bitlbee im.bitlbee.org
#
#	   setting			   example
#	bitlbee_servertag_regexp	^bitlbee[0-9]$
#

%IRSSI = (
    authors     => "Benoit Bourdin (bennyben)",
    contact     => "bennyben\@rezosup.net",
    name        => "Bitlbee Reconnect",
    description => "reconnect and identify to bitlbee",
    license     => "GPL",
    url         => "http://irssi.org/"
);

my $bitlbee_pass = "nopass";

sub on_join {
	my ($server, $channame, $nick, $host) = @_;                                                                                                                                      
	$channame =~ s/^://;
	
	if($nick eq $server->{nick}) {
		my $reg = Irssi::settings_get_str('bitlbee_servertag_regexp');
		if($channame eq "#bitlbee" && $server->{tag} =~ /$reg/) {
			if($bitlbee_pass eq "nopass") {
				Irssi::print "connected to bitlbee, please identify with /bitlbee_ident <password>";
			} else {
				$server->send_raw("PRIVMSG #bitlbee :identify ".$bitlbee_pass);
				Irssi::print "bitlbee identification in progress...";
			}
		}
	}
};

sub on_bitlbee_ident {
	my ($args, $server, $witem) = @_;
	$bitlbee_pass = $args;
	my $reg = Irssi::settings_get_str('bitlbee_servertag_regexp');
	
	if($server && $server->{tag} =~ /$reg/) {
		$server->send_raw("PRIVMSG #bitlbee :identify ".$bitlbee_pass);
	}
}

Irssi::settings_add_str($IRSSI{'name'}, 'bitlbee_servertag_regexp', 'bitlbee');

Irssi::signal_add('message join', 'on_join');
Irssi::command_bind('bitlbee_ident', 'on_bitlbee_ident');
