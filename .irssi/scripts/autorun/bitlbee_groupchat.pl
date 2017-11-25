use strict;
use vars qw($VERSION %IRSSI);
use Irssi;

$VERSION = '0.1';
%IRSSI = (
    authors     => 'Tijmen Ruizendaal',
    contact     => 'timing@fokdat.nl',
    name        => 'bitlbee_groupchat',
    description => 'When BitlBee puts you into a self created groupchat Irssi doesnt know what to do. Now it does',
    license     => 'GPLv2',
    url         => 'http://fokdat.nl/~tijmen/software/irssi-bitlbee.html',
    changed     => 'today',
);


sub window_created{
	my $window=shift;
	print Irssi::Window::	
}

Irssi::signal_add('window created','window_created');
