package EPUB3::Builder;
use 5.008005;
use strict;
use warnings;
use Smart::Args;
use File::Slurp qw/ read_file write_file /;
use Carp;
use Class::Accessor::Lite rw => [qw/ cover_image  navi /];
use Archive::Zip qw/:ERROR_CODES/;

use constant DEBUG => $ENV{epub_builder_debug} ? 1 : 0;

our $VERSION = "0.01";

sub new {
    args(
        my $class  => 'ClassName',
        my $output => { isa => 'Str', optional => 1 },
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

    unless ($self->navi) {
        $self->set_navi({
            data => $self->build_default_navi,
            save_name => 'navi.xhtml',
        });
    }

    $self->container->write_file;
    $self->opf->write_file;
}

sub opf {
    my $self = shift;

    $self->{opf} ||= do {
        require EPUB3::Builder::OPF;
        EPUB3::Builder::OPF->new({ base_dir => $self->dir });
    };
}

sub container {
    my $self = shift;
    $self->{container} ||= do {
        require EPUB3::Builder::Container;
        EPUB3::Builder::Container->new({ base_dir => $self->dir });
    };
}


sub item          { require EPUB3::Builder::Item;           EPUB3::Builder::Item->new({ dir => shift->opf->dir }) }
sub image_item    { require EPUB3::Builder::Item::Image;    EPUB3::Builder::Item::Image->new({ dir => shift->opf->dir }) }
sub document_item { require EPUB3::Builder::Item::Document; EPUB3::Builder::Item::Document->new({ dir => shift->opf->dir }) }
sub css_item      { require EPUB3::Builder::Item::Css;      EPUB3::Builder::Item::Css->new({ dir => shift->opf->dir }) }

sub add_image {
    my $self = shift;
    my $img = $self->image_item->add(@_);
    $self->opf->add($img);
}

sub set_cover_image {
    my $self = shift;
    my $cover = $self->image_item->add(@_);
    $cover->is_cover(1);

    $self->cover_image($cover);
    $self->opf->add($cover);
}

sub add_item {
    my $self = shift;
    my $item = $self->item->add(@_);
    $self->opf->add($item);
}

sub add_css {
    my $self = shift;
    my $item = $self->css_item->add(@_);
    $self->opf->add($item);
}

sub add_document {
    my $self = shift;
    my $doc = $self->document_item->add(@_);
    $self->opf->add($doc);
}

sub build_navi {
    my $self = shift;
    my $args = shift || {};

    require EPUB3::Builder::Navi;
    EPUB3::Builder::Navi->new($args)->build;
}

sub build_default_navi {
    my $self = shift;
    my ($seq_number_title, @navi_list);

    for my $item (@{$self->opf->spine->item_list}) {
        $seq_number_title++;
        push @navi_list, {
            title => $seq_number_title,
            link  => $item->href,
        };
    }

    return $self->build_navi({
        navi_list => \@navi_list
    });
}

sub set_navi {
    my $self = shift;
    my $args = shift || {};
    $args->{attr}{properties} ||= "nav";
    $args->{attr}{linear} ||= "no";

    my $navi = $self->document_item->add_navi($args);
    $self->navi($navi);
    $self->opf->add($navi);
}

sub multi_set {
    args(
        my $self      => 'Object',
        my $navi      => { isa => 'Str', optional => 1 },
        my $cover_img => { isa => 'Str', optional => 1 },
    );

    $self->set_cover_image({ file_path => $cover_img })  if $cover_img;
    $self->set_navi({ file_path => $navi  })  if $navi;
}

sub multi_add {
    args(
        my $self      => 'Object',
        my $items     => { isa => 'ArrayRef[Str]', default => [] },
        my $documents => { isa => 'ArrayRef[Str]', default => [] },
        my $attr      => { isa => 'HashRef',       default => [] },
    );

    for my $doc_path (@$documents) {
        $self->add_document({ file_path => $doc_path, attr => {}  });
    }
    for my $item_path (@$items) {
        $self->add_item({ file_path => $item_path, attr => {} });
    }
}

sub zip_pack {
    my $self = shift;
    my $zip = Archive::Zip->new();

    $zip->addString("application/epub+zip", "mimetype");

    for my $item ( @{$self->opf->manifest->item_list} ) {
        $zip->addFileOrDirectory($item->path, 'OEBPS/'.$item->href);
    }

    $zip->addFile($self->opf->path, "OEBPS/content.opf");
    $zip->addFile($self->container->path, "META-INF/container.xml");

    return $zip;
}

sub output {
    args(
        my $self => 'Object',
        my $path => { isa => 'Str', optional => 1 },
    );

    $self->{output_path} = $path if $path;

    $self->build;
    my $zip = $self->zip_pack;
    unless ( $zip->writeToFileNamed( $self->{output_path} ) == AZ_OK ) {
        croak 'write error';
    }

}


1;
__END__

=encoding utf-8

=head1 NAME

EPUB3::Builder - generate EPUB3 file

=head1 SYNOPSIS

    use EPUB3::Builder;
    my $builder =  EPUB3::Builder->new;

    # set metadata
    my $metadata = $builder->opf->metadata;
    $metadata->author('author');
    $metadata->title('title');
    $metadata->lang('ja'); #default is en
    $metadata->dir('ltr'); #default is ltr
    $metadata->modified('2013-04-22T08:58:17Z'); #default is current gmtime

    # add book items
    $builder->multi_set({
        cover_image => "cover.png",
        navi        => "nav.xhtml",
    });

    $builder->multi_add({
        document => [
            "cover.xhtml",
            "1.xhtml",
            "2.xhtml",
        ],
        item => [
            "test.png",
            "style.css",
        ],
    });

    $builder->output({ path => 'myBook.epub' });

=head1 DESCRIPTION

  Build OEBPS/content.opf and META-INF/container.xml, mimetype from your book content.
  And create Zip archive.

=head1 LICENSE

Copyright (C) tokubass.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

tokubass

=cut

