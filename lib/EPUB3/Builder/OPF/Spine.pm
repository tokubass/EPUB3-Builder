package EPUB3::Builder::OPF::Spine;
use strict;
use warnings;
use Smart::Args;
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
    my $item = shift;
 
    $self->item_list({ item => $item });
}

sub item_list {
    args(
        my $self => 'Object',
        my $item => { isa => 'Object', optional => 1 },
    );

    push @{$self->{item_list}}, $item if $item;
    $self->{item_list};
}

sub build {
    my $self = shift;
    my $build_items;

    for my $item (@{$self->item_list}) {
        $build_items .= $item->print_to_spine;
    }

    sprintf($self->template, $build_items);


}

sub template {  
    my $self = shift; 
    my $page_progression_direction = $self->page_progression_direction;
    qq{<spine page-progression-direction="${page_progression_direction}" >\n%s</spine>\n}
}

sub page_direction {
    my $self = shift;

}


1;
