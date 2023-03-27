#!/usr/bin/raku


use NCurses;

my $win = initscr();
start_color;
init_pair(1, COLOR_WHITE, COLOR_RED);
init_pair(2, COLOR_WHITE, COLOR_BLUE);
color_set(1,0);
for 0..10 -> $i {
	mvaddstr($i,$i, "Hello world!");
	mvaddstr($i-1,$i-1, "            ");
	sleep(0.1);
	nc_refresh;
}
getch;

LEAVE {
	delwin($win) if $win;
	endwin;
}
