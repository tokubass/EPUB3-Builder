package myTestUtil;
use strict;
use warnings;
use HTML::Tidy;
use Test::More;
use Exporter qw/import/;

our @EXPORT_OK = qw/is_after_tidy/;

sub is_after_tidy {
    Test::More::is(
        HTML::Tidy->new->clean($_[0]),
        HTML::Tidy->new->clean($_[1]),
        $_[2],
    );
}

1;


