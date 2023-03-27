#!/usr/bin/raku

use Net::SSH2:from<Perl5>;

my $ssh = Net::SSH2.new;

$ssh.connect("suragu.net");

$ssh.check_hostkey("ask");

$ssh.auth_publickey("diego", "/home/diego/.ssh/id_ed25519.pub", "/home/diego/.ssh/id_ed25519");

my $chan = $ssh.channel();

$chan.exec("ls");

.say while <$chan>;
