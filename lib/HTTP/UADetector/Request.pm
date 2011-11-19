package HTTP::UADetector::Request;
use strict;
use Scalar::Util qw//;

sub new {
    my($class, $stuff) = @_;

    if (!defined $stuff) {
        bless { env => \%ENV }, 'HTTP::UADetector::Request::Env';
    }
    elsif (ref $stuff eq 'HASH') {
        # PSGI hash - translate it to an HTTP::Headers object
        require HTTP::Headers;
        my $hdrs = HTTP::Headers->new(
            map {
                (my $field = $_) =~ s/^HTTPS?_//;
                ( $field => $stuff->{$_} );
            }
            grep {
                /^(?:HTTP|CONTENT|COOKIE)/i
            }
            keys %$stuff
        );
        bless { r => $hdrs }, 'HTTP::UADetector::Request::HTTPHeaders';
    }
    elsif (UNIVERSAL::isa($stuff, 'Apache')) {
        bless { r => $stuff }, 'HTTP::UADetector::Request::Apache';
    }
    elsif (Scalar::Util::blessed($stuff) && $stuff->isa('HTTP::Headers')) {
        bless { r => $stuff }, 'HTTP::UADetector::Request::HTTPHeaders';
    }
    else {
        bless { env => { HTTP_USER_AGENT => $stuff } }, 'HTTP::UADetector::Request::Env';
    }
}

package HTTP::UADetector::Request::Env;

sub get {
    my($self, $header) = @_;
    $header =~ tr/-/_/;
    return $self->{env}->{'HTTP_' . uc($header)};
}

package HTTP::UADetector::Request::Apache;

sub get {
    my($self, $header) = @_;
    return $self->{r}->header_in($header);
}

package HTTP::UADetector::Request::HTTPHeaders;

sub get {
    my($self, $header) = @_;
    return $self->{r}->header($header);
}

1;
