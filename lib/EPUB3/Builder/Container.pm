package EPUB3::Builder::Container;
use strict;
use warnings;
use Smart::Args;
use IO::File;
use File::Spec::Functions qw/catfile/;
use File::Slurp ();

sub new {
    args(
        my $class => 'ClassName',
        my $base_dir  => 'Str',
    );

    my $self = bless {
        base_dir => $base_dir, 
    } => $class;

    $self->make_dir;
    $self;
}

sub make_dir {
    shift->dir;
}

sub path {
    my $self = shift;

    $self->{path} ||= catfile($self->{base_dir}, '/META-INF/container.xml');
}

sub dir {
    my $self = shift;

    $self->{dir} ||= do{
        require File::Basename;
        require File::Path;

        my $dir = File::Basename::dirname($self->path);
        File::Path::mkpath($dir);
        $dir;
    }
}

sub build {
    my $container =<<"CONTAINER";
<?xml version="1.0" encoding="utf-8"?>
<container xmlns="urn:oasis:names:tc:opendocument:xmlns:container" version="1.0">
  <rootfiles>
    <rootfile full-path="OEBPS/content.opf" media-type="application/oebps-package+xml" />
  </rootfiles>
</container>
CONTAINER

    return $container;
}

sub write_file {
    my $self = shift;
    File::Slurp::write_file($self->path, $self->build); 
}



1;
