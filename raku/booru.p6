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
		
		for 0..99 -> $i {
			my $post = $json<post>[$i];
			if $safe and $post<rating> ne "general" {
				next;
			} else {
				@urls.push($post<file_url>);
			}
		}
		return @urls;
	}
}

sub MAIN(Bool :$s = False, #= Only prompt safe posts.
				*@tags #= Tags. I don't think I have to explain this.
	   ) {
	unless defined $s {
		$s = False;
	}
	my Gelbooru $booru = Gelbooru.new;
	for $booru.get_posts(@tags, $s) -> $i {
		say $i;
	}

}
