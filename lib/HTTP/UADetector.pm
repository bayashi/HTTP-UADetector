package HTTP::UADetector;
use strict;
use warnings;
use HTTP::UADetector::Request;
use HTTP::UADetector::Util;

require HTTP::UADetector::ParseBrowser;
require HTTP::UADetector::ParseBot;

our $VERSION = '0.01';

sub new {
    my($class, $stuff) = @_;

    my $request = HTTP::UADetector::Request->new($stuff);
    my $ua = $request->get('User-Agent');

    my $parser = ($ua =~ m!http://[^/]+!) ? 'Bot' : 'Browser';
    my $self = bless { _request => $request }, "$class\::Parse$parser";

    $self->parse;

    return $self;
}

# utility for subclasses
sub make_accessors {
    my ($class, @attr) = @_;

    for my $attr (@attr) {
        no strict 'refs';
        *{"$class\::$attr"} = sub { shift->{$attr} };
    }
}

sub raw {
    shift->{_request}->get('User-Agent');
}

sub parse {
    die 'abstract method! should be implemented in subclass';
}

sub no_match {
    my $self = shift;
    require Carp;
    Carp::carp(
        shift->raw,
        ': No match. Might be new variants. ',
        'Please contact the author of HTTP::UADetector!',
    ) if $^W;
}

1;

__END__

=head1 NAME

HTTP::UADetector - detect UserAgent


=head1 SYNOPSIS

    use HTTP::UADetector;

    my $ua = HTTP::UADetector->new('Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0)');

    $ua->raw; # raw UADetector string

    $ua->name;     # Internet Explorer
    $ua->version;  # 15.0.874.54
    $ua->vendor    # Microsoft

    $ua->type; # browser(browser or bot or mobile(mobile browser is browser))

    $ua->os;          # Windows 7
    $ua->os_name;     # Windows
    $ua->os_version;  # 7

    $ua->mobile->name; # wrapper HTTP::MobileAgent



=head1 DESCRIPTION

HTTP::UADetector detects UserAgent


=head1 REPOSITORY

HTTP::UADetector is hosted on github
<http://github.com/bayashi/HTTP-UADetector>


=head1 AUTHOR

Dai Okabayashi E<lt>bayashi@cpan.orgE<gt>


=head1 SEE ALSO

inspired by L<HTTP::MobileAgent>


=head1 LICENSE

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

=cut
