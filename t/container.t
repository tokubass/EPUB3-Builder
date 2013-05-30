use Test::More;
use strict;
use warnings;
use EPUB3::Builder;
use File::Basename;
use lib 't/lib';
use myTestUtil qw/ is_after_tidy /;

my $builder =  EPUB3::Builder->new;
my $content = $builder->container->build;
my $expected =<<"CONTAINER";
<?xml version="1.0" encoding="utf-8"?>
<container xmlns="urn:oasis:names:tc:opendocument:xmlns:container" version="1.0">
  <rootfiles>
    <rootfile full-path="OEBPS/content.opf" media-type="application/oebps-package+xml" />
  </rootfiles>
</container>
CONTAINER

is_after_tidy($expected,$content);

done_testing;


