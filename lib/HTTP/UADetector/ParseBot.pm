package HTTP::UADetector::ParseBot;
use strict;
use warnings;
use parent qw/HTTP::UADetector/;

__PACKAGE__->make_accessors(
    qw/name version vendor type os os_name os_version/
);

sub parse {
    my $self = shift;

    my $agent = $self->raw;

    my $parsed = +{};
    if ($agent =~ m!^Mozilla/\d+\.\d+!) {
        $parsed = _parse_mozilla($agent);
    }
    else {
        $parsed = _parse_not_mozilla($agent);
    }

    $self->{name}    = $parsed->{name};
    $self->{version} = $parsed->{version};
    $self->{vendor} = $parsed->{vendor};
    $self->{type} = $parsed->{type};
}

sub _parse_mozilla {
    my $agent = shift;

    my ($name, $version, $vendor, $type);

    if ($agent =~ m!(Googlebot)/([\d\.]+); \+http://www\.google\.com/!) {
        $name    = $1;
        $version = $2;
        $vendor  = 'google';
        $type    = 'bot';
    }
    elsif($agent =~ m!(bingbot)/([\d\.]+); \+http://www\.bing\.com/!) {
        $name    = $1;
        $version = $2;
        $vendor  = 'microsoft';
        $type    = 'bot';
    }
    elsif($agent =~ m!(Baiduspider)/([\d\.]+); \+http://www\.baidu\.com/!) {
        $name    = $1;
        $version = $2;
        $vendor  = 'baidu';
        $type    = 'bot';
    }
    elsif($agent =~ m!(YodaoBot)/([\d\.]+); http://www\.yodao\.com/!) {
        $name    = $1;
        $version = $2;
        $vendor  = 'youdao';
        $type    = 'bot';
    }
    elsif($agent =~ m!(MJ12bot)/v([\d\.]+); http://www\.majestic12\.co\.uk/!) {
        $name    = $1;
        $version = $2;
        $vendor  = 'majestic12';
        $type    = 'bot';
    }
    elsif($agent =~ m!(YandexBot)/([\d\.]+); \+http://yandex\.com/!) {
        $name    = $1;
        $version = $2;
        $vendor  = 'yandex';
        $type    = 'bot';
    }

    return +{
        name      => $name,
        version   => $version,
        vendor    => $vendor,
        type      => $type,
    };
}


sub _parse_not_mozilla {
    my $agent = shift;

    my ($name, $version, $vendor, $type);

    if ($agent =~ m!^(Baiduspider)\+\(\+http://www\.baidu\.com/!) {
        $name    = $1;
        $version = $2;
        $vendor  = 'baidu';
        $type    = 'bot';
    }
    elsif($agent =~ m!^(ichiro)/([\d\.]+) \(http://help\.goo\.ne\.jp/!) {
        $name    = $1;
        $version = $2;
        $vendor  = 'goo';
        $type    = 'bot';
    }
    elsif($agent =~ m!^(livedoor FeedFetcher)/([\d\.]+) \(http://reader\.livedoor\.com/!) {
        $name    = $1;
        $version = $2;
        $vendor  = 'livedoor';
        $type    = 'bot';
    }
    elsif($agent =~ m!(Googlebot-Mobile)/([\d\.]+); \+http://www\.google\.com/!) {
        $name    = $1;
        $version = $2;
        $vendor  = 'google';
        $type    = 'bot';
    }

    return +{
        name      => $name,
        version   => $version,
        vendor    => $vendor,
        type      => $type,
    };
}

1;

__END__

=head1 NAME

HTTP::UADetector::ParseBot - detect bot


=head1 SYNOPSIS

    use HTTP::UADetector::ParseBot;


=head1 DESCRIPTION

HTTP::UADetector::ParseBot is



=head1 AUTHOR

Dai Okabayashi E<lt>bayashi@cpan.orgE<gt>


=head1 SEE ALSO

L<HTTP::UADetector>


=head1 LICENSE

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

=cut
