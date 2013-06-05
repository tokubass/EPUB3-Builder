package EPUB3::Builder::OPF::Manifest;
use strict;
use warnings;
use Carp;
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
    my $item = shift or croak '$item is undef';

    $self->set_uniq_id($item);

    $item->can('is_nav') && i$item->is_navi
        ? unshift @{$self->{item_list}}, $item
        : push    @{$self->{item_list}}, $item;
}

sub set_uniq_id {
    my $self = shift;
    my $item = shift;
    $item->id(sprintf("_%s_%s",  $self->item_count , File::Basename::basename($item->href) ) );
}

sub item_list { shift->{item_list} }

sub item_count { scalar @{shift->{item_list}} }

sub build {
    my $self = shift;
    my $build_items;

    my $exist_navi;
    for my $item (@{$self->item_list}) {
        $exist_navi = 1 if $item->can('is_navi') && $item->is_navi;
        $build_items .= $item->print_to_manifest;
    }

    croak 'navigation document not found in manifest' unless $exist_navi;

    sprintf($self->template, $build_items);
}

sub template {
    qq{<manifest>\n%s</manifest>\n}
}

1;

__END__
