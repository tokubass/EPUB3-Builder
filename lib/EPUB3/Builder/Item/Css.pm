package EPUB3::Builder::Item::Css;
use strict;
use warnings;
use parent 'EPUB3::Builder::Item';
use Encode;

sub save_data {
    my $self = shift;
    my $args = shift;

    $args->{data} = encode_utf8($args->{data});

    $self->SUPER::save_data($args);

}

1;

