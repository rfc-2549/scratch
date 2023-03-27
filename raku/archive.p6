#!/usr/bin/raku

use Archive::Libarchive;

sub create_archive(Str $dir) {
	my $tar = Archive::Libarchive.new:
			operation => LibarchiveWrite,
			file => "example.tar.gz";
	try {
		$tar.write-header($dir,
					   uname => $*USER,
					   gname => $*GROUP
					  );
		$tar.write-data($dir);
		CATCH {
			.Str.say;
		}
	}
	$tar.close;
}

sub extract_archive(Str $file) {
	my $tar = Archive::Libarchive.new:
			operation => LibarchiveExtract,
			file => $file;
	try {
		$tar.extract;
		CATCH {
			.Str.say;
			return False;
		}
	}
	return True;
}

say create_archive("/usr/bin") # Or whatever

