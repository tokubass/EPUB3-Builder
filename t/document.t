use Test::More;
use strict;
use warnings;
use EPUB3::Builder;
use File::Basename;
use lib 't/lib';
use myTestUtil qw/ is_after_tidy /;

subtest 'add_document' => sub {
    my $builder =  EPUB3::Builder->new;
    my $file_path = 't/var/denden/OEBPS/bodymatter_0_1.xhtml';
    my $file_name = basename($file_path);

    $builder->add_document({
        file_path => $file_path,
        save_name => 'document/bodymatter_0_1.xhtml',
        attr => { linear => 'no' },
    });

    $builder->set_navi({
        data => $builder->build_default_navi,
        save_name => 'navi.xhtml',
    });


    my $expected =<<"SPINE";
<spine page-progression-direction="ltr" >
  <itemref idref="_1_navi.xhtml" linear="no" />
  <itemref idref="_0_$file_name" linear="no" />
</spine>
SPINE

    is_after_tidy($builder->opf->spine->build, $expected);
};




done_testing;


