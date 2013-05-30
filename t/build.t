use Test::More;
use strict;
use warnings;
use EPUB3::Builder;
use File::Temp qw/ tempfile /;

subtest 'build_epub' => sub {
    my $builder =  EPUB3::Builder->new;
    my $metadata = $builder->opf->metadata;
    $metadata->author('author');
    $metadata->title('title');
    $metadata->lang('ja');

    my $dir = 't/var/denden/OEBPS';

    $builder->multi_set({
        cover_img => "$dir/cover.png",
        navi      => "$dir/nav.xhtml",
    });

    $builder->multi_add({
        documents => [
            "$dir/cover.xhtml",
            "$dir/bodymatter_0_0.xhtml",
            "$dir/bodymatter_0_1.xhtml",
            "$dir/bodymatter_0_2.xhtml",
            "$dir/bodymatter_0_3.xhtml",
            "$dir/bodymatter_0_4.xhtml",
            "$dir/bodymatter_0_5.xhtml",
            "$dir/bodymatter_0_6.xhtml",
        ],
        items => [
            "$dir/fig01.png",
            "$dir/style.css",
        ],
    });

    my ($fh, $output) = tempfile( SUFFIX => '.epub' );
    $builder->output({ path => $output });
    unlink $output;
    ok(1);
};

done_testing;


