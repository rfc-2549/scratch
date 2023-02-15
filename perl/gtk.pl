#!/usr/bin/perl

use Gtk3 '-init';
use feature 'say';
use strict;

# Pseudo cookie clicker.

my $win = Gtk3::Window->new('toplevel');
my $win2 = Gtk3::Window->new('toplevel');
my $btn = Gtk3::Button->new('Exit');
my $counter = 0;
$btn->signal_connect(
		clicked => sub {
			$btn->set_label("Clicked $counter times");
			say "You have clicked the button";
			$counter++;
		}
);

$win->add($btn);
$win->show_all;
Gtk3->main;

