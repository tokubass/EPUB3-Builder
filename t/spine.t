use Test::More;
use strict;
use warnings;
use EPUB3::Builder;
use File::Basename;
use lib 't/lib';
use myTestUtil qw/ is_after_tidy /;

subtest 'add_multi' => sub {
    my $builder =  EPUB3::Builder->new;

    my $file_path = 't/var/denden/OEBPS/bodymatter_0_1.xhtml';
    my $file_name = basename($file_path);

    $builder->add_document({
        file_path => $file_path,
        save_name => 'document/bodymatter_0_1.xhtml',
    });

    $builder->set_cover_image({
        file_path => "t/var/denden/OEBPS/cover.png",
    });

    $builder->set_navi({
        data => $builder->build_default_navi,
        save_name => 'document/nav.xhtml',
    });



    my $expected =<<"SPINE";
<spine page-progression-direction="ltr" >
  <itemref idref="_2_nav.xhtml" linear="no" />
  <itemref idref="_0_$file_name" />
</spine>
SPINE

    is_after_tidy($builder->opf->spine->build, $expected);
};



done_testing;


