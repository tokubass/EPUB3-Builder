use Test::More;
use strict;
use warnings;
use EPUB3::Builder;
use File::Basename;

subtest 'build_opf' => sub {
    my $builder =  EPUB3::Builder->new({ output => '.' });
    my $dir = 't/var/denden/OEBPS';

    $builder->multi_set({
        cover_img => "$dir/cover.png",
        navi      => "$dir/nav.xhtml",
    });

    $builder->multi_add({
        document => [
            "$dir/bodymatter_0_0.xhtml",
            "$dir/bodymatter_0_1.xhtml",
            "$dir/bodymatter_0_2.xhtml",
            "$dir/bodymatter_0_3.xhtml",
            "$dir/bodymatter_0_4.xhtml",
            "$dir/bodymatter_0_5.xhtml",
            "$dir/bodymatter_0_6.xhtml",
        ],
    });

    ok($builder->opf->build);
};

done_testing;
