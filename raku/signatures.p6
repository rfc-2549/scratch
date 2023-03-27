#!/usr/bin/env raku

sub hello(Int:D $x) {
	say $x;
}

hello(Int.new(42));
