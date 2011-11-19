use strict;
use warnings;
use Test::More 0.88;

BEGIN { use_ok 'HTTP::UADetector' }

my @test_data = (
    # ua, name, version, vendor, type, platform, os_name, os_version

    # mozilla
    [
        'Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20100101 Firefox/7.0.1',
        'Firefox', '7.0.1', 'mozilla', 'browser', 'Windows', 'Windows XP', 'XP',
    ],

    # not mozilla
    [
        'ApacheBench/2.0.40-dev',
        'ApacheBench', '2.0.40-dev', 'apache software foundation', 'bot', undef, undef, undef,
    ],

);

for (@test_data) {
    my($ua, @data) = @$_;
    my $agent = HTTP::UADetector->new($ua);
    isa_ok $agent, 'HTTP::UADetector';
    isa_ok $agent, 'HTTP::UADetector::ParseBrowser';
    is $agent->raw,        $ua, "ua is $ua";
    is $agent->name,       $data[0], 'name';
    is $agent->version,    $data[1], 'version';
    is $agent->vendor,     $data[2], 'vendor';
    is $agent->type,       $data[3], 'type';
    is $agent->os,         $data[4], 'os';
    is $agent->os_name,    $data[5], 'os_name';
    is $agent->os_version, $data[6], 'os_version';

}

done_testing;
