#!/usr/bin/env raku


class X::Gelbooru::NotSuccess is Exception {
	method message() {
		"Error in the HTTP request.";
	}
}

class Gelbooru {
	use HTTP::Tiny;
	use JSON::Tiny;
	
	has $.http_client;

	method new() {
		my $http = HTTP::Tiny.new;
		self.bless(http_client => $http);
	}
	
	method get_posts(@tags where @tags.all ~~ Str:D, Bool:D $safe) {
		my $tags_str = @tags.join("+"); # Gelbooru separates tags
		# with a '+' because the guy
		# who runs it is retarded

		my $res = self.http_client.get("https://gelbooru.com/index.php?page=dapi&s=post&q=index&tags=" ~ $tags_str ~ "&json=1");

		# Throw exception if the request was not successful.
		unless $res<status> == 200 {
			X::Gelbooru::NotSuccess.new.throw;
		}
		my $json = from-json($res<content>.decode);
		my @urls;
		my @post_tags; 
		
		for 0..99 -> $i {
			my $post = $json<post>[$i];
			if $safe and $post<rating> ne "general" {
				next;
			} else {
				@urls.push($post<file_url>);
				@post_tags.push($post<tags>);
			}
		}
		return @urls, @post_tags;
	}
}
use NCurses;

constant WIDTH  = 80;
constant HEIGHT = 10;

# For example
my Gelbooru $booru = Gelbooru.new;
my (@choices, @tags) = $booru.get_posts(["touhou", "hime_cut", "rating:general"], True);
my Int $scroll_begin = 0;
my Int $scroll_end = 5;
my @current_choices = @choices[$scroll_begin..$scroll_end];
my Int $n_choices = @current_choices.elems;
my @current_tags = @tags[$scroll_begin..$scroll_end];
my Int $highlight = 1;

sub print_menu($menu_win, $highlight) {
	my $x = 2;
	my $y = 2;
	box($menu_win, 50, 20);
	

	for 0..5 -> $i {
		# Highlight the choice
		if $highlight == $i + 1 {
			wattron($menu_win, A_REVERSE);
			mvwprintw($menu_win, $y, $x, sprintf("%s", @current_choices[$i]));
			wattroff($menu_win, A_REVERSE);
		} else {
			mvwprintw($menu_win, $y, $x, sprintf("%s", @current_choices[$i]));
		}
		$y++;
	}
	wrefresh($menu_win);
}


my $choice = 0;

initscr;
clear;
noecho;
my $startx = Int((80 - WIDTH) / 2);
my $starty = Int((20 - HEIGHT) / 2);

my $menu_win = newwin(HEIGHT, WIDTH, $starty, $startx);
keypad($menu_win, True);
mvprintw(0,0, "Use arrow keys to navigate between array elements");
nc_refresh;
print_menu($menu_win, $highlight);

while True {
	my $c = wgetch($menu_win);

	given $c {
		when KEY_UP {
			($highlight == 1) ?? ($highlight = $n_choices) !! ($highlight--);
			nc_refresh;
		}
		when KEY_DOWN {
			($highlight == $n_choices) ?? ($highlight = 1) !! ($highlight++);
			nc_refresh;
		}
		when 10 { # Enter
			$choice = $highlight;
			shell("xdg-open @current_choices[$choice]");
			nc_refresh;
		}
		default {
			mvprintw(24, 0, sprintf("Character pressed is = %3d Hopefully it can be printed as '%c'", $c, $c));
			nc_refresh;
		}
	}
	mvprintw(30, 0, sprintf("Tags: %s", @current_tags[$highlight]));
	if $highlight > 5 {
		$scroll_begin += 5;
		$scroll_end += 5;
		@current_choices = @choices[$scroll_begin..$scroll_end];
		mvprintw(20, 0, sprintf("begin: %d end: %d", $scroll_begin, $scroll_end));
	}
	print_menu($menu_win, $highlight);

	last if $choice != 0;
}

mvprintw(23, 0, sprintf("You chose choice #%d with choice '%s'\n", $choice, @current_choices[$choice - 1]));

LEAVE {
	clrtoeol;
	nc_refresh;
	endwin;
}
