use strict;
use warnings;
use Test::Subs debug => 1;
use OAuth::Consumer;
use LWP::UserAgent;
use threads;

my ($ua, $r, $url);

test {
	$ua = OAuth::Consumer->new(
			oauth_request_token_url => 'http://notesync.org:8080/oauth/request_token',
			oauth_authorize_url => 'http://notesync.org:8080/oauth/authorize/emily/Y5LLgf/',
			oauth_access_token_url => 'http://notesync.org:8080/oauth/access_token'
		);
};

test {
	$r = $ua->get('http://notesync.org:8080/api/1.0/emily');
};

test {
	$r->code() == 401;
};

test {
	$url = $ua->get_request_token();
};

test {
	threads->create( sub { LWP::UserAgent->new()->get($url) } )->detach();
	1;
};

my ($token, $secret);

test {
	($token, $secret) = $ua->get_access_token();
};

test {
	$r = $ua->get('http://notesync.org:8080/api/1.0/emily');
};

test {
	$r->is_success;
};

__END__

test {
	$token eq 'accesskey' and $secret eq 'accesssecret'
};

test {
	$r = $ua->get('http://term.ie/oauth/example/echo_api.php?test=foo');
};

test {
	$r->content eq 'test=foo'
};
