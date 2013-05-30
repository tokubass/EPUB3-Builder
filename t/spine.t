use Test::More;
use strict;
use warnings;
use EPUB3::Builder;
use File::Basename;
use lib 't/lib';
use myTestUtil qw/ is_after_tidy /;

subtest 'add_item' => sub {
    my $builder =  EPUB3::Builder->new({ output => '.' });
    my $file_path = 't/var/denden/OEBPS/cover.png';
    my $file_name = basename($file_path);

    $builder->set_cover_img({
        file_path => $file_path,
    });

    my $expected =<<"SPINE";
<spine page-progression-direction="ltr" >
  <itemref idref="0_$file_name" linear="no" />
</spine>
SPINE

    is_after_tidy($builder->opf->spine->build, $expected);
};

subtest 'add_multi' => sub {
    my $builder =  EPUB3::Builder->new({ output => '.' });

    my $file_path = 't/var/denden/OEBPS/cover.png';
    my $file_name = basename($file_path);

    $builder->set_cover_img({
        file_path => $file_path,
        save_name => 'image/cover.png',
    });

    my $file_path2 = 't/var/denden/OEBPS/nav.xhtml';
    my $file_name2 = basename($file_path2);

    $builder->set_navi({
        file_path => $file_path2,
        save_name => 'document/nav.xhtml',
    });

    my $file_path3 = 't/var/denden/OEBPS/bodymatter_0_1.xhtml';
    my $file_name3 = basename($file_path3);

    $builder->add_document({
        file_path => $file_path3,
        save_name => 'document/bodymatter_0_1.xhtml',
    });

    my $expected =<<"SPINE";
<spine page-progression-direction="ltr" >
  <itemref idref="0_$file_name" linear="no" />
  <itemref idref="1_$file_name2" />
  <itemref idref="2_$file_name3" />
</spine>
SPINE

    is_after_tidy($builder->opf->spine->build, $expected);
};



done_testing;


