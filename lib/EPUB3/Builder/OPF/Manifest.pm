package EPUB3::Builder::OPF::Manifest;
use strict;
use warnings;
use Smart::Args;
use File::Basename ();

sub new {
    args(
        my $class => 'ClassName',
    );

    bless {
        item_list => [],
    } => $class;
}

sub add {
    my $self = shift;
    my $item = shift;

    $self->set_uniq_id($item);
    $self->item_list({ item => $item });
}

sub set_uniq_id {
    my $self = shift;
    my $item = shift;
    $item->id(sprintf("_%s_%s",  $self->item_count , File::Basename::basename($item->href) ) );
}

sub item_list {
    args(
        my $self => 'Object',
        my $item => { isa => 'Object', optional => 1 },
    );

    push @{$self->{item_list}}, $item if $item;
    $self->{item_list};
}

sub item_count { scalar @{shift->{item_list}} }

sub build {
    my $self = shift;
    my $build_items;

    for my $item (@{$self->item_list}) {
        $build_items .= $item->print_to_manifest;
    }

    sprintf($self->template, $build_items);
}

sub template {
    qq{<manifest>\n%s</manifest>\n}
}

1;

__END__
