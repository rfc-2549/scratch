#!/usr/bin/raku


use NCurses;

my $win = initscr();

mvaddstr(10,0, "Hello world!");
mvaddstr(11,0, "Press any key to exit...");
nc_refresh:
getch;

LEAVE {
	delwin($win) if $win;
	endwin;
}
