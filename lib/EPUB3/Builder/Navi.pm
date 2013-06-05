package EPUB3::Builder::Navi;
use strict;
use warnings;
use Smart::Args;
use Class::Accessor::Lite rw => [qw/ page_title toc_title navi_list /];

sub new {
    args(
        my $class => 'ClassName',
        my $page_title => { isa => 'Str', default => 'Navigation' },
        my $toc_title  => { isa => 'Str', default => 'table of contents' },
        my $navi_list  => { isa => 'ArrayRef[HashRef]' },
);


    bless {
        page_title => $page_title,
        toc_title  => $toc_title,
        navi_list  => $navi_list,
    } => $class;

}

sub build {
    my $self = shift;
    my $page_title = $self->page_title;
    my $toc_title  = $self->toc_title;

    my @list;
    for my $li_item (@{$self->navi_list}) {
        push @list, sprintf(qq{<li><a href="%s"><span>%s</span></a></li>}, $li_item->{link}, $li_item->{title});
    }
    my $list_str = join("\n", @list);


    <<"NAVI";
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops" xml:lang="ja" lang="ja">
<head>
<meta charset="utf-8" />
<title>$page_title</title>
<style type="text/css">
  ol {list-style-type: none;}
</style>
</head>
<body class="frontmatter" epub:type="frontmatter">

<nav id="toc" epub:type="toc">
<h2>$toc_title</h2>
<ol>
$list_str
</ol>
</nav>

</body>
</html>
NAVI

}

1;
