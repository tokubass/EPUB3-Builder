package EPUB3::Builder::Item;
use strict;
use warnings;
use Smart::Args;
use File::Slurp qw/ read_file write_file /;
use EPUB3::Builder::Util;
use Class::Accessor::Lite rw => [qw/ dir path id href /];

sub new {
    args(
        my $class => 'ClassName',
        my $dir   => 'Str',
    );
    bless {
        dir  => $dir,
        path => '',
        href => '',
        media_type => '',
    }, $class;
}

sub add {
    my $self = shift;
    my $file_path = $_[0]->{file_path};
    $file_path ? $self->save_file(@_) : $self->save_data(@_);

    return $self;
}

sub save_file {
    args(
        my $self      => 'Object',
        my $file_path => { isa => 'Str'},
        my $save_name => { isa => 'Str',   optional => 1 },
        my $option    => { isa => 'HashRef', default => {} },
    );

    my $data = EPUB3::Builder::Util->load_file({
        file_path => $file_path,
        opt       => $option,
    });

    $self->save_data({
        data      => $data,
        save_name => $save_name || $file_path,
    });
}

sub save_data {
    args(
        my $self => 'Object',
        my $data => 'Value',
        my $save_name => 'Str',
        my $option    => { isa => 'HashRef', default => {} },
    );

    require File::Spec;
    require File::Basename;
    require File::Path;

    my $save_path = File::Spec->catfile($self->dir, $save_name);
    File::Path::make_path(File::Basename::dirname($save_path));

    write_file($save_path, $option, $data);

    $self->path($save_path);
    $self->href($save_name);

}

sub media_type {
    my $self = shift;
    $self->{media_type} = do {
        require MIME::Types;
        my ($type) = MIME::Types::by_suffix($self->path);
        $type;
    };
}


sub print_to_manifest {
    my $self = shift;

    my $template = qq{  <item media-type="%s" href="%s" id="%s"  />\n};

    sprintf($template, $self->media_type, $self->href, $self->id);
}

sub print_to_spine {
    my $self = shift;
    return '' unless $self->media_type eq 'application/xhtml+xml';

    my $template = qq{  <itemref idref="%s" />\n};

    sprintf($template, $self->id);
}

1;
