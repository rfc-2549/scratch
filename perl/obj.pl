#!/usr/bin/perl

package fd;
use feature 'say';
use Moose;

has 'fd'   => (is => 'ro', isa => 'Int');
has 'path' => (is => 'ro', isa => 'Str');

1;
package main;
my $file = fd->new(fd => 3, path => "hello.txt");

say $file->fd;
