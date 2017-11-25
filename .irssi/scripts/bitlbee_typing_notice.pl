# [#bitlbee] set typing_notice true
# <@root> typing_notice = `true'
# AND
# /statusbar window add typing_notice
#
# After changing Irssi settings reload the script.
# 
# Changelog:
# 
# 10-31-2004:
# Sends typing notice to the bitlbee server when typing a message in irssi. bitlbee > 0.92
#
# 06-11-2004:
# shows [typing: ] in #bitlbee with multiple users.
#
# 

use strict;
use Irssi::TextUI;

use vars qw($VERSION %IRSSI);

$VERSION = '1.0';
%IRSSI = (
    authors     => 'Tijmen "timing" Ruizendaal',
    contact     => 'tijmen@fokdat.nl',
    name        => 'bitlbee_typing_notice',
    description => 'adds an item to the status bar wich shows [typing] when someone is typing a message on the supported IM-networks',
    license => 'GPLv2',
    url     => 'http://fokdat.nl/~tijmen/software/index.html',
    changed => '10-31-2004',
);

Irssi::settings_add_str('misc', 'bitlbee_send_typing', undef);
my %typing;
my %tag;
my $line;
my %out_typing;
my $bitlbee_channel = "#bitlbee";
my $bitlbee_server_tag = "localhost";
my $lastkey;
my $command_char = Irssi::settings_get_str('cmdchars');
my $to_char = Irssi::settings_get_str("completion_char");
my $send_typing = Irssi::settings_get_str('bitlbee_send_typing');

sub chan_sync{
  my( $channel ) = @_;
  if( $channel->{topic} eq "Welcome to the control channel. Type \x02help\x02 for help information." ){
    $bitlbee_channel = $channel->{name};
  }
}

sub event_notice {
  my ($server, $msg, $from, $address) = @_;
  my ($my_nick, $msg) = split(/:/,$msg,2);
  if ($msg eq "* Typing a message *"){
    Irssi::signal_stop();
    $typing{$from} = 1;
    Irssi::timeout_remove($tag{$from});
    $tag{$from} = Irssi::timeout_add(7000, 'empty', $from);
       
    my $window = Irssi::active_win();
    my $channel = $window->get_active_name();
    if ($from eq $channel || $channel eq $bitlbee_channel || $channel =~ /#chat_0/){
      Irssi::statusbar_items_redraw('typing_notice');
    }
  }
}
sub event_privmsg {
  my ($server, $data, $from, $address) = @_;
  if ($typing{$from} == 1){
    delete($typing{$from});
  }
  my $window = Irssi::active_win();
  my $channel = $window->get_active_name();
  
  if ($channel eq $from || $channel eq $bitlbee_channel || $channel =~ /#chat_0/){ 
    delete($typing{$channel});
    Irssi::timeout_remove($tag{$from});
    Irssi::statusbar_items_redraw('typing_notice');
  }
}
sub typing_notice {
  my ($item, $get_size_only) = @_;
  my $window = Irssi::active_win();
  my $channel = $window->get_active_name();
    
  if (exists($typing{$channel})){
    $item->default_handler($get_size_only, "{sb typing}", 0, 1);
  }else{
    $item->default_handler($get_size_only, "", 0, 1);
    Irssi::timeout_remove($tag{$channel});
  }
  if ($channel eq $bitlbee_channel || $channel =~ /#chat_0/){
    foreach my $key (keys(%typing) )
    {
      $line = $line." ".$key;
    }
    if ($line ne "" ){
      $item->default_handler($get_size_only, "{sb typing:$line}", 0, 1);
      $line = "";
    }
  } 
}
sub empty{
  my $from = shift;
  delete($typing{$from});
  Irssi::statusbar_items_redraw('typing_notice');
}
sub window_change{
  Irssi::statusbar_items_redraw('typing_notice');
}
sub key_pressed{
  if($send_typing){
    my $key = shift;
#    print $key;
    if($key != 9 && $key != 10 && $lastkey != 27 && $key != 27 && $lastkey != 91 && $key != 126){
#      print "fetched: ".$key;
      my $server = Irssi::active_server();
      my $window = Irssi::active_win();
      my $nick = $window->get_active_name();
      if ($server->{tag} eq $bitlbee_server_tag && $nick ne "(status)"){
        if($nick eq $bitlbee_channel){
          my $input = Irssi::parse_special("\$L");
          my ($first_word) = split(/ /,$input);
          if ($input !~ /^$command_char.*/ && $first_word =~ s/$to_char$//){
            send_typing($first_word);
          }
  	}else{
          my $input = Irssi::parse_special("\$L");
          if ($input !~ /^$command_char.*/){
            send_typing($nick);
	  }
        }
      }
    }
    $lastkey = $key; 
  }
}
sub out_empty{
  my $nick = shift;
  delete($out_typing{$nick});
}
sub send_typing{
  my $nick = shift;
  if(!exists($out_typing{$nick})){
    my $window = Irssi::active_win();
    $window->command("^CTCP $nick TYPING 1");
    #print "typing to $nick";
    Irssi::timeout_add_once(6000, 'out_empty', $nick);
    $out_typing{$nick} = 1;
  }
}
Irssi::signal_add("event notice", "event_notice");
Irssi::signal_add("event privmsg", "event_privmsg");
Irssi::signal_add_last('window changed', 'window_change');
Irssi::statusbar_item_register('typing_notice', undef, 'typing_notice');
Irssi::signal_add_last('gui key pressed', 'key_pressed');
Irssi::signal_add_last('channel sync','chan_sync');
Irssi::statusbars_recreate_items();
