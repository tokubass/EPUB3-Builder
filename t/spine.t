use Test::More;
use strict;
use warnings;
use EPUB3::Builder;
use File::Basename;
use lib 't/lib';
use myTestUtil qw/ is_after_tidy /;

subtest 'add_multi' => sub {
    my $builder =  EPUB3::Builder->new;

    my $file_path = 't/var/denden/OEBPS/nav.xhtml';
    my $file_name = basename($file_path);

    $builder->set_navi({
        file_path => $file_path,
        save_name => 'document/nav.xhtml',
    });

    my $file_path2 = 't/var/denden/OEBPS/bodymatter_0_1.xhtml';
    my $file_name2 = basename($file_path2);

    $builder->add_document({
        file_path => $file_path2,
        save_name => 'document/bodymatter_0_1.xhtml',
    });

    my $expected =<<"SPINE";
<spine page-progression-direction="ltr" >
  <itemref idref="_0_$file_name" linear="no" />
  <itemref idref="_1_$file_name2" />
</spine>
SPINE

    is_after_tidy($builder->opf->spine->build, $expected);
};



done_testing;


