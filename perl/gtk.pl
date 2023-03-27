#!/usr/bin/perl

# Cookie clicker

use Gtk2 '-init';
use feature 'say';
use strict;

my $win = Gtk2::Window->new('toplevel');
my $win2 = Gtk2::Window->new('toplevel');
my $btn = Gtk2::Button->new('Clicked 0 times!');
my $counter = 1;

$btn->signal_connect(
		clicked => sub {
			$btn->set_label("Clicked $counter times!");
			say "You have clicked the button";
			$counter++;
		}
);

$win->add($btn);
$win->show_all;
Gtk2->main;

