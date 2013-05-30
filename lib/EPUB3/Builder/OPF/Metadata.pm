package EPUB3::Builder::OPF::Metadata;
use strict;
use warnings;
use Smart::Args;
use Time::Piece;
use Class::Accessor::Lite rw => [qw/ author title dir lang modified /];

sub new {
    args(
        my $class => 'ClassName',
    );

    bless {
        uuid     => '',
        author   => '',
        title    => '',
        dir      => '',
        lang     => '',
        modified => '',
    } => $class;
}

sub build {
    args(
        my $self => 'Object',
    );

    my $UUID     = $self->uuid;
    my $author   = $self->author   || '';
    my $title    = $self->title    || '';
    my $lang     = $self->lang     || 'en';
    my $dir      = $self->dir      || 'ltr';
    my $modified = $self->modified || gmtime()->datetime . 'Z';

    my $metadata_temp =<<"METADATA";
  <metadata xmlns:dc="http://purl.org/dc/elements/1.1/">
    <dc:identifier id="identifier0">urn:uuid:${UUID}</dc:identifier>
    <meta refines="#identifier0" property="identifier-type" scheme="xsd:string">uuid</meta>
    <dc:title id="title0">${title}</dc:title>
    <meta refines="#title0" property="display-seq">1</meta>
    <dc:creator id="creator0">${author}</dc:creator>
    <meta refines="#creator0" property="display-seq">1</meta>
    <dc:format>application/epub+zip</dc:format>
    <dc:language>${lang}</dc:language>
    <meta property="dcterms:modified">${modified}</meta>
    <meta name="cover" content="_cover.png" />
  </metadata>
METADATA

}

sub uuid {
    my $self = shift;
    $self->{uuid} ||= do{
        require Data::UUID;
        Data::UUID->new->create_str;
    };
}

1;
