package myTestUtil;
use strict;
use warnings;
use HTML::Tidy::LibXML;
use Test::More;
use Exporter qw/import/;

our @EXPORT_OK = qw/is_after_tidy/;

sub is_after_tidy {
    is(
        HTML::Tidy::libXML->new->clean($_[0], 'utf8', 1),
        HTML::Tidy::libXML->new->clean($_[1], 'utf8', 1),
        $_[2],
    );
}

1;

