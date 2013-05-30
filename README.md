# NAME [![Build Status](https://travis-ci.org/tokubass/EPUB3-Builder.png)](https://travis-ci.org/tokubass/EPUB3-Builder)

EPUB3::Builder - generate EPUB3 file

# SYNOPSIS

    use EPUB3::Builder;
    my $builder =  EPUB3::Builder->new;

    # set metadata
    my $metadata = $builder->opf->metadata;
    $metadata->author('author');
    $metadata->title('title');
    $metadata->lang('ja'); #default is en
    $metadata->dir('ltr'); #default is ltr
    $metadata->modified('2013-04-22T08:58:17Z'); #default is current gmtime

    # add book items
    $builder->multi_set({
        cover_img => "cover.png",
        navi      => "nav.xhtml",
    });

    $builder->multi_add({
        document => [
            "cover.xhtml",
            "1.xhtml",
            "2.xhtml",
        ],
        item => [
            "test.png",
            "style.css",
        ],
    });

    $builder->output({ path => 'myBook.epub' });

# DESCRIPTION

    Build OEBPS/content.opf and META-INF/container.xml, mimetype from your book content.
    And create Zip archive.

# LICENSE

Copyright (C) tokubass.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

tokubass
