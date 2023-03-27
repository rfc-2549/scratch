#!/usr/bin/perl

use HTTP::Tiny::UA;
use v5.36.0;

my $http = HTTP::Tiny::UA->new(
					   agent => "curl/7.86"
					  );

print $http->get("https://suragu.net/xdxd.html")->content;

