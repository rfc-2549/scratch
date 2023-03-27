#!/usr/bin/perl -w
use v5.36;

use strict;

# Returns the greatest parameter
sub max {
	my ($x, $y) = @_;
	return $x > $y ? $x : $y;
}

say max(6,6);


