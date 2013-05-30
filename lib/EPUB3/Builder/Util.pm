package EPUB3::Builder::Util;
use strict;
use warnings;
use Smart::Args;
use File::Slurp;

use Mouse::Util::TypeConstraints;
subtype 'ExistsFilePath'
    => as 'Str'
    => where { -e $_ }
    => message { "'$_' file is not found" };

sub load_file {
    args(
        my $class => 'ClassName',
        my $file_path => { isa => 'ExistsFilePath'},
        my $opt       => { isa => 'HashRef' },
    );

    read_file($file_path, $opt);
}

1;
