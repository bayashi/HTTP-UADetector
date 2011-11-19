package HTTP::UADetector::Util;
use strict;
use warnings;

sub detect_os {
    my $str = shift or return +{};

    my ($os, $os_name, $os_version);

    if ($str =~ m!Win(?:dows )?(?:NT 5\.1|XP)!) {
        $os = 'Windows';
        $os_name = 'Windows XP';
        $os_version = 'XP';
    }

    return +{
        os => $os,
        os_name => $os_name,
        os_version => $os_version,
    };
}

1;
