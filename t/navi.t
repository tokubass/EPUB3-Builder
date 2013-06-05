use Test::More;
use strict;
use warnings;
use EPUB3::Builder;
use File::Basename;
use lib 't/lib';
use myTestUtil qw/ is_after_tidy /;

subtest 'build_navi' => sub {
    my $builder =  EPUB3::Builder->new;

    my $navi_xhtml = $builder->build_navi({
        page_title => 'page title',
        toc_title => 'toc title',
        navi_list => [{
            title => '1',
            link => '1.xhtml',
        },{
            title => '2',
            link => '2.xhtml',
        }],
    });

     my $expected =<<"NAVI";
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops" xml:lang="ja" lang="ja">
<head>
<meta charset="utf-8" />
<title>page title</title>
<style type="text/css">
  ol {list-style-type: none;}
</style>
</head>
<body class="frontmatter" epub:type="frontmatter">

<nav id="toc" epub:type="toc">
<h2>toc title</h2>
<ol>
<li><a href="1.xhtml"><span>1</span></a></li>
<li><a href="2.xhtml"><span>2</span></a></li>
</ol>
</nav>

</body>
</html>
NAVI

    is_after_tidy($navi_xhtml, $expected);
};

subtest 'build default navi' => sub {
    my $builder =  EPUB3::Builder->new;

    my $dir = 't/var/denden/OEBPS';

    $builder->multi_set({
        cover_img => "$dir/cover.png",
        navi      => "$dir/nav.xhtml",
    });

    $builder->multi_add({
        documents => [
            "$dir/cover.xhtml",
            "$dir/bodymatter_0_0.xhtml",
        ],
        items => [
            "$dir/fig01.png",
            "$dir/style.css",
        ],
    });

    my $expected =<<"NAVI";
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops" xml:lang="ja" lang="ja">
<head>
<meta charset="utf-8" />
<title>Navigation</title>
<style type="text/css">
  ol {list-style-type: none;}
</style>
</head>
<body class="frontmatter" epub:type="frontmatter">

<nav id="toc" epub:type="toc">
<h2>table of contents</h2>
<ol>
<li><a href="t/var/denden/OEBPS/cover.png"><span>1</span></a></li>
<li><a href="t/var/denden/OEBPS/nav.xhtml"><span>2</span></a></li>
<li><a href="t/var/denden/OEBPS/cover.xhtml"><span>3</span></a></li>
<li><a href="t/var/denden/OEBPS/bodymatter_0_0.xhtml"><span>4</span></a></li>
<li><a href="t/var/denden/OEBPS/fig01.png"><span>5</span></a></li>
<li><a href="t/var/denden/OEBPS/style.css"><span>6</span></a></li>
</ol>
</nav>

</body>
</html>
NAVI

    is_after_tidy($builder->build_default_navi, $expected);
};

done_testing;


