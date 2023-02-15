#!/usr/bin/perl

# "My politics are based in honestly and transparency"
# -- Enrique Pastor, Youth and Free time Councillor

# faneto: get all the subdomains from the Certificate Transparency Log
# Because, apparently, there is a log for every certificate made.

use Mojo::UserAgent;
use Getopt::Std;
use List::MoreUtils qw(uniq);
use strict;
use warnings;
use Data::Dumper;

use v5.30;

# Handle args
our ( $opt_v, $opt_o );
getopts('o:v');

my $ua     = Mojo::UserAgent->new;
my $domain = $ARGV[ @ARGV - 1 ];
unless($domain) {
	say "USAGE: ./faneto.pl [-o OUTPUT] [-v] DOMAIN";
	exit;
}

my $url_to_get = sprintf( "https://crt.sh/?q=%s&output=json", $domain );
say "Requesting $url_to_get" if $opt_v;
my $res = $ua->get($url_to_get)->result;

if ( $res->code != 200 ) {
	die "Server did not return 200";
}

my $data = $res->json;
my $i    = 0;
my @subdomains;

foreach (@$data) {
	push(@subdomains, $data->[$i]->{'name_value'});
	$i++;
}

if ($opt_o) {
	open(my $FH, ">", "$opt_o" ) or die $!;
	foreach ( uniq(sort(@subdomains)) ) {
		say ($FH $_);
	}
	
	say "Saved output to $opt_o" if ($opt_v);
	close($FH);

}
else {
	say join("\n", uniq(sort(@subdomains)));
}

