use Test::More;
use strict;
use warnings;
use EPUB3::Builder;
use File::Basename qw/ basename /;
use lib 't/lib';
use myTestUtil qw/ is_after_tidy /;

subtest 'set_cover_image' => sub {
    my $builder =  EPUB3::Builder->new;
    my $file_path = 't/var/denden/OEBPS/cover.png';
    my $file_name = basename($file_path);

    $builder->set_cover_image({
        file_path => $file_path,
    });

    ok($builder->cover_image->is_cover);

    my $expected =<<"MANIFEST";
<manifest>
  <item media-type="image/png" href="$file_path" id="_0_$file_name" properties="cover-image" />
</manifest>
MANIFEST

    is_after_tidy($builder->opf->manifest->build, $expected);
};

subtest 'set_cover_image_with_save_name' => sub {
    my $builder =  EPUB3::Builder->new;
    my $file_path = 't/var/denden/OEBPS/cover.png';
    my $save_name = 'image/cover.png';
    my $file_name = basename($file_path);

    $builder->set_cover_image({
        file_path => $file_path,
        save_name => $save_name,
    });
    my $expected =<<"MANIFEST";
<manifest>
  <item media-type="image/png" href="$save_name" id="_0_$file_name" properties="cover-image" />
</manifest>
MANIFEST

    is_after_tidy($builder->opf->manifest->build, $expected);
};


subtest 'add_document' => sub {
    my $builder =  EPUB3::Builder->new;
    my $file_path = 't/var/denden/OEBPS/bodymatter_0_0.xhtml';
    my $save_name = 'document/bodymatter_0_0.xhtml';
    my $file_name = basename($file_path);

    $builder->add_document({
        file_path => $file_path,
        save_name => $save_name,
    });

    my $expected =<<"MANIFEST";
<manifest>
  <item media-type="application/xhtml+xml" href="$save_name" id="_0_$file_name"  />
</manifest>
MANIFEST

    is_after_tidy($builder->opf->manifest->build, $expected);
};

subtest 'set_navi' => sub {
    my $builder =  EPUB3::Builder->new;
    my $file_path = 't/var/denden/OEBPS/nav.xhtml';
    my $save_name = 'document/nav.xhtml';
    my $file_name = basename($file_path);

    $builder->set_navi({
        file_path => $file_path,
        save_name => $save_name,
    });

    my $expected =<<"MANIFEST";
<manifest>
  <item media-type="application/xhtml+xml" href="$save_name" id="_0_$file_name" properties="nav" />
</manifest>
MANIFEST

    is_after_tidy($builder->opf->manifest->build, $expected);
};


subtest 'add_multi' => sub {
    my $builder =  EPUB3::Builder->new;
    my $file_path = 't/var/denden/OEBPS/cover.png';
    my $save_name = 'image/cover.png';
    my $file_name = basename($file_path);

    $builder->set_cover_image({
        file_path => $file_path,
        save_name => $save_name,
    });

    my $file_path2 = 't/var/denden/OEBPS/nav.xhtml';
    my $save_name2 = 'document/nav.xhtml';
    my $file_name2 = basename($file_path2);


    $builder->set_navi({
        file_path => $file_path2,
        save_name => $save_name2,
    });

    my $file_path3 = 't/var/denden/OEBPS/bodymatter_0_1.xhtml';
    my $save_name3 = 'document/bodymatter_0_1.xhtml';
    my $file_name3 = basename($file_path3);

    $builder->add_document({
        file_path => $file_path3,
        save_name => $save_name3,
    });


    my $expected =<<"MANIFEST";
<manifest>
  <item media-type="image/png" href="$save_name" id="_0_$file_name" properties="cover-image" />
  <item media-type="application/xhtml+xml" href="$save_name2" id="_1_$file_name2" properties="nav" />
  <item media-type="application/xhtml+xml" href="$save_name3" id="_2_$file_name3"  />
</manifest>
MANIFEST

    is($builder->opf->manifest->item_count, 3);
    is_after_tidy($builder->opf->manifest->build, $expected);
};



done_testing;


