package myTestUtil;
use strict;
use warnings;
use XML::Compare;
use Test::More;
use Exporter qw/import/;

our @EXPORT_OK = qw/is_after_tidy/;

sub is_after_tidy {
    my $xml_compare = XML::Compare->new( namespace_strict => 1 );
    ok($xml_compare->is_same($_[0], $_[1]),  $_[2], );
}

1;

