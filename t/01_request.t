use strict;
use warnings;
use Test::More 0.88;

BEGIN { use_ok 'HTTP::UADetector' }

# various way to make request

my $ua = "Mozilla/1.0";

{
    my $agent = HTTP::UADetector->new($ua);
    isa_ok $agent, 'HTTP::UADetector';
    is $agent->raw, $ua;
}

{
    local $ENV{HTTP_USER_AGENT} = $ua;
    my $agent = HTTP::UADetector->new($ua);
    isa_ok $agent, 'HTTP::UADetector';
    is $agent->raw, $ua;
}

SKIP: {
    eval { require HTTP::Headers; };
    skip "no HTTP::Headers", 2 if $@;

    my $header = HTTP::Headers->new;
    $header->header('User-Agent' => $ua);
    my $agent = HTTP::UADetector->new($header);
    isa_ok $agent, 'HTTP::UADetector';
    is $agent->raw, $ua;
}

SKIP: {
    eval { require HTTP::Headers::Fast; };
    skip "no HTTP::Headers::Fast", 2 if $@ || $HTTP::Headers::Fast::VERSION < 0.10; # 0.11 or later supports ->isa

    my $header = HTTP::Headers::Fast->new;
    $header->header('User-Agent' => $ua);
    my $agent = HTTP::UADetector->new($header);
    isa_ok $agent, 'HTTP::UADetector';
    is $agent->raw, $ua;
}

{
    # mock object
    package Apache;
    sub header_in {
        my($r, $header) = @_;
        return $r->{$header};
    }

    package main;
    my $r = bless { 'User-Agent' => $ua }, 'Apache';
    my $agent = HTTP::UADetector->new($r);
    isa_ok $agent, 'HTTP::UADetector';
    is $agent->raw, $ua;
}

done_testing;
