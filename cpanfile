requires 'Bread::Board';
requires 'Bread::Board::Container';
requires 'Data::GUID';
requires 'Mojo::Base';
requires 'Mojolicious::Commands';
requires 'Mouse';
requires 'Mouse::Role';
requires 'Scalish';
requires 'aliased';
requires 'feature';
requires 'namespace::autoclean';
requires 'strictures';

on test => sub {
    requires 'Test::Mojo';
    requires 'Test::More';
};
