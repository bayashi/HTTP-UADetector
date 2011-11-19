use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'HTTP::UADetector',
    license             => 'perl',
    dist_author         => 'Dai Okabayashi <bayashi@cpan.org>',
    dist_version_from   => 'lib/HTTP/UADetector.pm',
    build_requires      => {
        'Test::More' => 0.88,
    },
    requires => {
        'Carp' => 0,
        'HTTP::MobileAgent' => 0.33,
        'HTTP::Headers' => 1.43,
        'Scalar::Util' => 1.14,
    },
    add_to_cleanup      => [ 'HTTP-UADetector-*' ],
    meta_merge     => {
      resources => {
        repository  => 'http://github.com/bayashi/HTTP-UADetector'
      }
    },
);

$builder->create_build_script();
