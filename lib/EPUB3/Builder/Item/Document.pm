package EPUB3::Builder::Item::Document;
use strict;
use warnings;
use parent 'EPUB3::Builder::Item';
use Class::Accessor::Lite rw => [qw/is_navi/];
use Encode;

sub add_navi {
    my $self = shift;
    $self->is_navi(1);
    $self->SUPER::add(@_);
}

sub data {
    my $self = shift;
    read_file($self->path);
}

sub save_file {
    my $self = shift;
    my $args = shift;

    $self->SUPER::save_file($args);

}

sub save_data {
    my $self = shift;
    my $args = shift;

    $args->{data} = encode_utf8($args->{data});

    $self->SUPER::save_data($args);

}

use constant IS_MANIFEST_ATTR => {
    properties => 1,
};

sub print_to_manifest {
    my $self = shift;
    my @basic_attr = (
        sprintf(q{media-type="%s"}, $self->media_type),
        sprintf(q{href="%s"},       $self->href),
        sprintf(q{id="%s"},         $self->id),
    );

    $self->attr->{properties} = 'nav' if $self->is_navi;

    my @extra_attr;
    for my $name ( keys %{$self->attr} ) {
        next unless IS_MANIFEST_ATTR->{$name};
        push @extra_attr,  sprintf(q{%s="%s"}, $name, $self->attr->{$name} );
    }


    sprintf(
        "<item %s />\n",
        join(' ' => (@basic_attr, @extra_attr))
    );
}

use constant IS_SPINE_ATTR => {
    linear => 1,
};

sub print_to_spine {
    my $self = shift;
    my @basic_attr = (
        sprintf(q{idref="%s"}, $self->id),
    );

    my @extra_attr;
    for my $name ( keys %{$self->attr} ) {
        next unless IS_SPINE_ATTR->{$name};
        push @extra_attr,  sprintf(q{%s="%s"}, $name, $self->attr->{$name} );
    }

    sprintf(
        "<itemref %s />\n",
        join(' ' => (@basic_attr, @extra_attr))
    );
}



1;

