use strict;
use warnings;
use Test::More 0.88;

BEGIN { use_ok 'HTTP::UADetector' }

my @test_data = (
    # ua, name, version, vendor, type, os, os_name, os_version

    # mozilla
    [
        'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)',
        'Googlebot', '2.1', 'google', 'bot', undef, undef, undef,
    ],
    [
        'Mozilla/5.0 (compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm)',
        'bingbot', '2.0', 'microsoft', 'bot', undef, undef, undef,
    ],
    [
        'Mozilla/5.0 (compatible; Baiduspider/2.0; +http://www.baidu.com/search/spider.html)',
        'Baiduspider', '2.0', 'baidu', 'bot', undef, undef, undef,
    ],
    [
        'Mozilla/5.0 (compatible; YodaoBot/1.0; http://www.yodao.com/help/webmaster/spider/; )',
        'YodaoBot', '1.0', 'youdao', 'bot', undef, undef, undef,
    ],
    [
        'Mozilla/5.0 (compatible; MJ12bot/v1.4.0; http://www.majestic12.co.uk/bot.php?+)',
        'MJ12bot', '1.4.0', 'majestic12', 'bot', undef, undef, undef,
    ],
    [
        'Mozilla/5.0 (compatible; YandexBot/3.0; +http://yandex.com/bots)',
        'YandexBot', '3.0', 'yandex', 'bot', undef, undef, undef,
    ],

    # not mozilla
    [
        'Baiduspider+(+http://www.baidu.com/search/spider.htm)',
        'Baiduspider', undef, 'baidu', 'bot', undef, undef, undef,
    ],
    [
        'ichiro/5.0 (http://help.goo.ne.jp/door/crawler.html)',
        'ichiro', '5.0', 'goo', 'bot', undef, undef, undef,
    ],
    [
        'livedoor FeedFetcher/0.01 (http://reader.livedoor.com/; 1 subscriber)',
        'livedoor FeedFetcher', '0.01', 'livedoor', 'bot', undef, undef, undef,
    ],
    [
        'DoCoMo/2.0 N905i(c100;TB;W24H16) (compatible; Googlebot-Mobile/2.1; +http://www.google.com/bot.html)',
        'Googlebot-Mobile', '2.1', 'google', 'bot', undef, undef, undef,
    ],
);

for (@test_data) {
    my($ua, @data) = @$_;
    my $agent = HTTP::UADetector->new($ua);
    isa_ok $agent, 'HTTP::UADetector';
    isa_ok $agent, 'HTTP::UADetector::ParseBot';
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
