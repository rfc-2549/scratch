#!/usr/bin/perl

use JSON::PP;
use strict;
use feature 'say';

my %hash = (
		  hello => "world",
		  hash_table => {
				 hello => "xdxd",
				  array => ["test", "test2"]
				}
		 );


say encode_json \%hash;
