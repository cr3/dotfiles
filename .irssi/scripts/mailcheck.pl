#!/usr/bin/perl -w

use Irssi;

use vars qw($VERSION %IRSSI);
$VERSION = "0.1";
%IRSSI = (
    authors     => "Marc Tardif",
    contact     => "marc\@interunion.ca",
    name        => "Mail Check",
    description => "Polls your unix mailbox for new mail",
    license     => "Public Domain",
    url         => "http://www.interunion.ca/~marc/software/irssi/",
    changed     => "Mon Mar  4 23:25:18 EET 2002"
);

use strict;

sub get_messages {
  my ($box) = @_;

  my %messages = ();
  my $inHeaders = 0;
  my $headers;
  my $time;

  local *F;
  if (open(F, $box)) {
    while (<F>) {
      chomp;
      if (/^From /) {
	my @fields = /^From [^ ]+ (.*)/;
	$time = $fields[0];
	$inHeaders = 1;
      } elsif ($inHeaders) {
	if ($_ eq "") {
	  $messages{$time} = $headers;

	  $inHeaders = 0;
	  $headers = {};
	} else {
	  $headers->{$1} = $2 if /^([^:]+): (.*)$/;
	}
      }
    }
    close(F);
  }

  return %messages;
}

sub newMail ( $$ ) {
  my ($box, $contents) = @_;
  my @newMail;
  foreach my $mail (keys %{$contents}) {
    push @newMail, {%{$contents->{$mail}}, BOX=>$box}
      unless exists $box->{contents}->{$mail};
  }
  return @newMail;
}

sub checkMail( $ ) {
  my $boxes = shift;
  my @changed = ();

  foreach my $box (keys %{$boxes}) {
    # Irssi::print "Checking $box";
    my @st = stat($box);
    my $mtime = $st[9];
    if ($mtime != $boxes->{$box}->{time}) {
      my %contents = get_messages($box);
      push @changed, newMail($boxes->{$box}, \%contents)
	if $boxes->{$box}->{time};

      $boxes->{$box}->{contents} = \%contents;
      $boxes->{$box}->{time} = $mtime;
    }
  }
  return @changed;
}

sub coalesce {
  foreach (@_) {
    return $_ if defined;
  }
  return undef;
}

my %boxes = ("/home/cr3/mail/inbox" => { name => "inbox", time => 0 } );

sub check {
  my @newMail = checkMail(\%boxes);
  foreach my $mail (@newMail) {
    my $row = $mail->{From} . ": " . coalesce($mail->{Subject}, "(no subject)");
    Irssi::print($row);
  }
}

Irssi::timeout_add(10000, "check", "");

check();
