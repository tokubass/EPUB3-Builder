package EPUB3::Builder::Item::Document;
use strict;
use warnings;
use parent 'EPUB3::Builder::Item';

sub data {
    my $self = shift;
    read_file($self->path, { binmode => ':utf8' });
}

sub save_file {
    my $self = shift;
    my $args = shift;

    $self->SUPER::save_file({ %$args, option => {binmode => ':utf8'} });

}

sub save_data {
    my $self = shift;
    my $args = shift;

    $self->SUPER::save_data({ %$args, option => {binmode => ':utf8'} });

}

sub is_navi {
    my $self = shift; 
    $self->{is_navi} = shift if (@_);
    $self->{is_navi};
}

sub print_to_manifest {
    my $self = shift;

    my $template = $self->is_navi
        ? qq{  <item media-type="%s" href="%s" id="%s" properties="nav" />\n}
        : qq{  <item media-type="%s" href="%s" id="%s"  />\n};

    sprintf($template, $self->media_type, $self->href, $self->id);
}

sub print_to_spine {
    my $self = shift;
    my $template = qq{  <itemref idref="%s" />\n};

    sprintf($template, $self->id);
}



1;

