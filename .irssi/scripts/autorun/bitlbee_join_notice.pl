#CHANGELOG:
#
#28-11-2004:
#it gives a join message in a query if a user joins #bitlbee and you hve a query open with that person.
#
#/statusbar window add join_notice
#use Data::Dumper;

use strict;
use Irssi::TextUI;
#use Irssi::Themes;

use vars qw($VERSION %IRSSI);

$VERSION = '1.0';
%IRSSI = (
    authors     => 'Tijmen "timing" Ruizendaal',
    contact     => 'tijmen@fokdat.nl',
    name        => 'bitlbee_join_notice',
    description => 'adds an item to the status bar wich shows [joined: <nicks>] when someone is joining #bitlbee',
    license => 'GPLv2',
    url     => 'http://fokdat.nl/~tijmen/software/irssi-bitlbee.html',
    changed => '11-28-2004',
);
my %online;
my %tag;
my $line;

Irssi::theme_register([
  'join', '{channick_hilight $0} {chanhost $1} has joined {channel $2}',
]);

sub event_join {
  my ($server, $channel, $nick, $address) = @_;
  if ($channel eq ":#bitlbee" && $server->{tag} eq "localhost"){
    $online{$nick} = 1;
    Irssi::timeout_remove($tag{$nick});
    $tag{$nick} = Irssi::timeout_add(7000, 'empty', $nick);
    Irssi::statusbar_items_redraw('join_notice');
    my $window = Irssi::window_find_item($nick);
    if($window){
      $window->printformat(MSGLEVEL_JOINS, 'join', $nick, $address, '#bitlbee'); 
    }
  }
}
sub join_notice {
  my ($item, $get_size_only) = @_; 
  foreach my $key (keys(%online) )
  {
    $line = $line." ".$key;
  }
  if ($line ne "" ){
    $item->default_handler($get_size_only, "{sb joined:$line}", undef, 1);
    $line = "";
  }else{
    $item->default_handler($get_size_only, "", undef, 1);
  } 
}
sub empty{
  my $nick = shift;
  delete($online{$nick});
  Irssi::timeout_remove($tag{$nick});
  Irssi::statusbar_items_redraw('join_notice');
}

Irssi::signal_add("event join", "event_join");
Irssi::statusbar_item_register('join_notice', undef, 'join_notice');
Irssi::statusbars_recreate_items();

