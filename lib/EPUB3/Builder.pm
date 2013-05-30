package EPUB3::Builder;
use 5.008005;
use strict;
use warnings;
use Smart::Args;
use File::Slurp qw/ read_file write_file /;
use Carp;
use EPUB3::Builder::Container;
use EPUB3::Builder::OPF;
use EPUB3::Builder::Item::Image;
use EPUB3::Builder::Item::Document;

use constant DEBUG => $ENV{epub_builder_debug} ? 1 : 0;

our $VERSION = "0.01";


sub new {
    args(
        my $class  => 'ClassName',
        my $output => { isa => 'Str', optional => DEBUG ? 1 : 0 },
    );

    my $self = bless {
        output_path => $output || '',
    }, $class;

    $self->init;
}

sub init {
    my $self = shift;

    $self->dir;
    warn sprintf("create temp dir: %s", $self->dir) if DEBUG;

    $self->opf;
    $self->container;
    return $self;
}

sub dir {
    my $self = shift;
    $self->{dir} ||= do {
        require File::Temp;
        File::Temp::tempdir( CLEANUP => DEBUG ? 0 : 1 );
    };
}

sub build {
    my $self = shift;
    $self->container->write_file;
    $self->opf->write_file;
}

sub opf {
    my $self = shift;
    $self->{opf} ||=
        EPUB3::Builder::OPF->new({ base_dir => $self->dir });
}

sub container {
    my $self = shift;
    $self->{container} ||=
        EPUB3::Builder::Container->new({ base_dir => $self->dir }); 
}

sub image_item { EPUB3::Builder::Item::Image->new({ dir => shift->opf->dir }) }

sub cover_img {
    my $self = shift;
    $self->{cover_img} = shift if (@_);
    $self->{cover_img};
}

sub set_cover_img {
    my $self = shift;

    my $cover = $self->image_item->add(@_);
    $cover->is_cover(1);

    $self->cover_img($cover);
    $self->opf->add($cover);
}

sub item { EPUB3::Builder::Item->new({ dir => shift->opf->dir }) }

sub add_item {
    my $self = shift;
    my $item = $self->item->add(@_);
    $self->opf->add($item);
}


{
no warnings;
*css_item = \&item;
*add_css = \&add_item;
}


sub document_item { EPUB3::Builder::Item::Document->new({ dir => shift->opf->dir }) }


sub add_document {
    my $self = shift;
    my $doc = $self->document_item->add(@_);
    $self->opf->add($doc);
}

sub navi {
    my $self = shift;
    $self->{navi} = shift if (@_);
    $self->{navi};
}

sub set_navi {
    my $self = shift;

    my $navi = $self->document_item->add(@_);
    $navi->is_navi(1);

    $self->navi($navi);
    $self->opf->add($navi);
}

sub multi_set {
    args(
        my $self  => 'Object',
        my $cover_img => { isa => 'Str', optional => 1 },
        my $navi  => { isa => 'Str', optional => 1 },
    );

    $self->set_cover_img({ file_path => $cover_img })  if $cover_img;
    $self->set_navi({ file_path => $navi  })  if $navi;
}

sub multi_add {
    args(
        my $self  => 'Object',
        my $document => { isa => 'ArrayRef[Str]', default => [] },
        my $item     => { isa => 'ArrayRef[Str]', default => [] },

    );

    for my $doc_path (@$document) {
        $self->add_document({ file_path => $doc_path });
    }
    for my $item_path (@$item) {
        $self->add_item({ file_path => $item_path });
    }
}

use Archive::Zip;
sub pack {
    my $self = shift;
    my $zip = Archive::Zip->new();

    # mimetype should come first
    $zip->addString("application/epub+zip", "mimetype");

    for my $item ( @{$self->opf->manifest->item_list} ) {
        $zip->addFileOrDirectory($item->path, 'OEBPS/'.$item->href);
    }

    $zip->addFile($self->opf->path, "OEBPS/content.opf");
    $zip->addFile($self->container->path, "META-INF/container.xml");
    $zip->writeToFileNamed( $self->{output_path} );
}


1;
__END__

=encoding utf-8

=head1 NAME

EPUB3::Builder - It's new $module

=head1 SYNOPSIS

    use EPUB3::Builder;

=head1 DESCRIPTION

EPUB3::Builder is ...

=head1 LICENSE

Copyright (C) tokubass.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

tokubass

=cut

