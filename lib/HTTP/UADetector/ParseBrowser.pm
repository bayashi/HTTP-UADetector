package HTTP::UADetector::ParseBrowser;
use strict;
use warnings;
use parent qw/HTTP::UADetector/;

__PACKAGE__->make_accessors(
    qw/name version vendor type os os_name os_version/
);

sub new {
    my $class = shift;
    my $args  = shift || +{};

    bless $args, $class;
}

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
    $self->{os} = $parsed->{os};
    $self->{os_name} = $parsed->{os_name};
    $self->{os_version} = $parsed->{os_version};
}

sub _parse_mozilla {
    my $agent = shift;

    my ($name, $version, $vendor, $type, $os);

    if ($agent =~ m!^Mozilla/5.0 \((Windows NT 5.1); rv:7.0.1\) Gecko/20100101 (Firefox)/([\d\.]+)!) {
        $os      = $1;
        $name    = $2;
        $version = $3;
        $vendor  = 'mozilla';
        $type    = 'browser';
    }

    return +{
        name      => $name,
        version   => $version,
        vendor    => $vendor,
        type      => $type,
        %{HTTP::UADetector::Util::detect_os($os)},
    };
}

sub _parse_not_mozilla {
    my $agent = shift;

    my ($name, $version, $vendor, $type, $os);

    if ($agent =~ m!^(ApacheBench)/([\d\.]+(?:-dev)?)!) {
        $name    = $1;
        $version = $2;
        $vendor  = 'apache software foundation';
        $type    = 'bot';
    }

    return +{
        name      => $name,
        version   => $version,
        vendor    => $vendor,
        type      => $type,
        %{HTTP::UADetector::Util::detect_os($os)},
    };
}


1;

__END__

=head1 NAME

HTTP::UADetector::ParseBrowser - detect Browser


=head1 SYNOPSIS

    use HTTP::UADetector::ParseBrowser;


=head1 DESCRIPTION

HTTP::UADetector::ParseBrowser is



=head1 AUTHOR

Dai Okabayashi E<lt>bayashi@cpan.orgE<gt>


=head1 SEE ALSO

L<HTTP::UADetector>


=head1 LICENSE

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

=cut
