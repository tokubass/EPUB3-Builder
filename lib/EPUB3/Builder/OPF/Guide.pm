package EPUB3::Builder::OPF::Guide;
use strict;
use warnings;
use Smart::Args;

sub new {
    args(
        my $class => 'ClassName',
    );

    bless {} => $class;
}

sub template {
    args(
        my $self => 'Object',
    );

    my $guide_temp =<<"GUIDE";
  <guide>
    <reference type="cover" title="表紙" href="cover.xhtml" />
    <reference type="text" title="スタートページ" href="bodymatter_0_0.xhtml" />
    <reference type="toc" title="目次" href="nav.xhtml" />
  </guide>
GUIDE


}  

1;
