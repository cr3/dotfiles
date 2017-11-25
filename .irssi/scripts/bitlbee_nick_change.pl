use strict;
use vars qw($VERSION %IRSSI);
use Irssi;
#use Data::Dumper;

$VERSION = '0.1';
%IRSSI = (
    authors	=> 'Tijmen Ruizendaal',
    contact	=> 'tijmen@fokdat.nl',
    name	=> 'bitlbee_nick_change',
    description	=> 'Shows an IM nickchange in an Irssi way.',
    license	=> 'GPLv2',
    url		=> 'http://fokdat.nl/~tijmen/software/irssi-bitlbee.html',
    changed	=> '06-11-2005',
);

sub message{
  my ($server, $msg, $nick, $address, $target) = @_;
  if($server->{tag} eq "localhost"){
    if($msg =~ /User.*changed name to/){
      $nick =$msg;
      $nick =~ s/User //;
      $nick =~ s/'//;
      $nick =~ s/`//;
      $nick =~ s/ changed name to.*//;
      my $window = $server->window_find_item($nick);  
      
      if($window){
        $window->printformat(MSGLEVEL_CRAP, 'nick_change',$msg);
        Irssi::signal_stop();
      }else{
        my $window = $server->window_find_item("#bitlbee");
        $window->printformat(MSGLEVEL_CRAP, 'nick_change',$msg);
        Irssi::signal_stop();
      }
    }
  }    
}

Irssi::signal_add_last ('message public', 'message');

Irssi::theme_register([
  'nick_change', '$0'
 ]);
