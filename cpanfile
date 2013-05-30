requires 'perl', '5.008001';
requires 'parent', '0';
requires 'Smart::Args', '0';
requires 'Mouse::Util::TypeConstraints', '0';
requires 'File::Slurp', '0';
requires 'Carp', '0';
requires 'Class::Accessor::Lite', '0';
requires 'Data::UUID', '0';


on 'test' => sub {
    requires 'Test::More', '0.98';
    requires 'HTML::Tidy::libXML', '0';
};

