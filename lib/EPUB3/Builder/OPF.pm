package EPUB3::Builder::OPF;
# OPF: Open Package Format
use strict;
use warnings;
use Smart::Args;
use File::Spec::Functions qw/catfile/;
use File::Slurp ();
use Encode;

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

    $self->{path} ||= catfile($self->{base_dir}, '/OEBPS/content.opf');
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

sub add {
    my $self = shift;
    my $item = shift;

    $self->manifest->add($item);
    $self->spine->add($item);
}

sub build {
    my $self = shift;

    my $metadata = $self->metadata->build;
    my $manifest = $self->manifest->build;
    my $spine = $self->spine->build;

    <<"OPF";
<?xml version="1.0" encoding="UTF-8"?>
<package xmlns="http://www.idpf.org/2007/opf" unique-identifier="identifier0" version="3.0">

$metadata
$manifest
$spine

</package>
OPF

}

sub write_file {
    my $self = shift;
    File::Slurp::write_file($self->path, encode_utf8($self->build));
}

sub metadata {
    args( my $self => 'Object' );

    $self->{metadata} ||= do{
        require EPUB3::Builder::OPF::Metadata;
        EPUB3::Builder::OPF::Metadata->new; 
    };
}

sub manifest {
    args( my $self => 'Object' );

    $self->{manifest} ||= do{
        require EPUB3::Builder::OPF::Manifest;
        EPUB3::Builder::OPF::Manifest->new; 
    };
}

sub spine {
    args( my $self => 'Object' );

    $self->{spine} ||= do{
        require EPUB3::Builder::OPF::Spine;
        EPUB3::Builder::OPF::Spine->new; 
    };
}



1;
