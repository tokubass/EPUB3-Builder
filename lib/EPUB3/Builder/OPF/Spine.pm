package EPUB3::Builder::OPF::Spine;
use strict;
use warnings;
use Smart::Args;
use Carp;
use Class::Accessor::Lite rw => [qw/ page_progression_direction /];

sub new {
    args(
        my $class => 'ClassName',
    );

    bless {
        page_progression_direction => 'ltr',
        item_list => [],
    } => $class;
}

sub add {
    my $self = shift;
    my $item = shift or croak '$item is undef';

    return unless $item->media_type eq 'application/xhtml+xml';

    $item->can('is_navi') && $item->is_navi
        ? unshift @{$self->{item_list}}, $item
        : push    @{$self->{item_list}}, $item;
}

sub item_list { shift->{item_list} }

sub build {
    my $self = shift;
    my $build_items;

    my $exist_navi;
    for my $item (@{$self->item_list}) {
        $exist_navi = 1 if $item->can('is_navi') && $item->is_navi;
        $build_items .= $item->print_to_spine;
    }

    croak 'navigation document not found in spine' unless $exist_navi;

    sprintf($self->template, $build_items);
}

sub template {
    my $self = shift;
    my $page_progression_direction = $self->page_progression_direction;
    qq{<spine page-progression-direction="${page_progression_direction}" >\n%s</spine>\n}
}

1;
