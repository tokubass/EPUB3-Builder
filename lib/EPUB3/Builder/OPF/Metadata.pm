package EPUB3::Builder::OPF::Metadata;
use strict;
use warnings;
use Smart::Args;
use Time::Piece;
use Class::Accessor::Lite rw => [qw/ author title dir lang modified /];
use Text::MicroTemplate::DataSection 'render_mt';

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

    my $metadata = render_mt('metadata', {
        uuid     => $self->uuid,
        author   => $self->author   || '',
        title    => $self->title    || '',
        lang     => $self->lang     || 'en',
        dir      => $self->dir      || 'ltr',
        modified => $self->modified || gmtime()->datetime . 'Z',
        cover_idref => '_cover.png',
    });


}

sub uuid {
    my $self = shift;
    $self->{uuid} ||= do{
        require Data::UUID;
        Data::UUID->new->create_str;
    };
}

1;

__DATA__

@@ metadata
<metadata xmlns:dc="http://purl.org/dc/elements/1.1/">
  <dc:identifier id="identifier0">urn:uuid:<?= $_[0]->{uuid} ?></dc:identifier>
  <meta refines="#identifier0" property="identifier-type" scheme="xsd:string">uuid</meta>
  <dc:title id="title0"><?= $_[0]->{title} ?></dc:title>
  <meta refines="#title0" property="display-seq">1</meta>
  <dc:creator id="creator0"><?= $_[0]->{author} ?></dc:creator>
  <meta refines="#creator0" property="display-seq">1</meta>
  <dc:format>application/epub+zip</dc:format>
  <dc:language><?= $_[0]->{lang} ?></dc:language>
  <meta property="dcterms:modified"><?= $_[0]->{modified} ?></meta>
  <meta name="cover" content="<?= $_[0]->{cover_idref} ?>" />
? if ($_[0]->{lang} eq 'ja') {
  <meta property="ebpaj:guide-version">1.1.2</meta>
? }
</metadata>
