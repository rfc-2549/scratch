#!/usr/bin/env raku


class X::Gelbooru::NotSuccess is Exception {
	method message() {
		"Error in the HTTP request.";
	}
}

class Gelbooru {
	use HTTP::Tiny;
	use JSON::Tiny;
	use Terminal::ANSIColor;
	
	has $.http_client;

	method new() {
		my $http = HTTP::Tiny.new;
		self.bless(http_client => $http);
	}
	
	method get_posts(@tags where @tags.all ~~ Str:D, Bool:D $safe, Int:D :$limit is copy = 20, Int:D :$page = 0) {
		my $tags_str = @tags.join("+"); # Gelbooru separates tags
		# with a '+' because the guy
		# who runs it is retarded

		my $res = self.http_client.get("https://gelbooru.com/index.php?page=dapi&pid=$page&s=post&q=index&tags=" ~ $tags_str ~ "&json=1&limit=$limit");

		# Throw exception if the request was not successful.
		unless $res<status> == 200 {
			X::Gelbooru::NotSuccess.new.throw;
		}
		my $json = from-json($res<content>.decode);
		if $json<@attributes><count> < $limit {
			say colored("The limit is greater than the count of posts with the given tags, changing limit", "underline red");
			$limit := $json<@attributes><count>;
		}
		my @urls;
		
		for 0..$limit -> $i {
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
				Int :$limit = 20, #= How many posts to get
				Int :$page = 0, #= Page to get
				*@tags #= Tags. I don't think I have to explain this.
	   ) {
	for $booru.get_posts(@tags, $s, limit => $limit, page => $page) -> $i {
	 	say $i;
	}
}
