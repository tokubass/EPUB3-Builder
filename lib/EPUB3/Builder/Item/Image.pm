package EPUB3::Builder::Item::Image;
use strict;
use warnings;
use parent 'EPUB3::Builder::Item';

sub data {
    my $self = shift;
    read_file($self->path, { binmode => ':raw' });
}

sub save_file {
    my $self = shift;
    my $args = shift;
    $self->SUPER::save_file({ %$args, option => {binmode => ':raw'} });
}

sub save_data {
    my $self = shift;
    my $args = shift;
    $self->SUPER::save_data({ %$args, option => {binmode => ':raw'} });
}

sub media_type {
    my $self = shift;
    $self->{media_type} = do {
        require MIME::Types;
        my ($type) = MIME::Types::by_suffix($self->path);

        unless ($type) {
            require Image::Info;
            my $img_info = Image::Info::image_type($self->path);
            if ($img_info->{error}) {
                die sprintf("Can't determine file type: %s", $img_info->{error});
            }
            $type = 'image/'.$img_info->{file_type};
        }

        lc($type);
    };
}

sub is_cover {
    my $self = shift; 
    $self->{is_cover} = shift if (@_);
    $self->{is_cover};
}

sub print_to_manifest {
    my $self = shift;
    my $template = $self->is_cover
        ? qq{  <item media-type="%s" href="%s" id="%s" properties="cover-image" />\n}
        : qq{  <item media-type="%s" href="%s" id="%s"  />\n};

    sprintf($template, $self->media_type, $self->href, $self->id);
}

1;

