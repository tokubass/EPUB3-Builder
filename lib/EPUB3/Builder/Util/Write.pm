package EPUB3::Builder::Util::Write;
use strict;
use warnings;
use File::Path;
use Exporter qw/import/;
our @EXPORT_OK = qw/write/;

sub write {
    my $self = shift;

    mkpath($self->dir);
    open (my $fh, '>', $self->path) or die $!;

    my $content = $self->build;
    $fh->print($content);
}


1;
