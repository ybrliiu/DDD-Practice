package DDDPractice::Domain::Model::Role::Entity {

  use Mouse::Role;
  use DDDPractice::Exporter;
  use Carp qw( carp );
  use namespace::autoclean;

  requires qw( same_identity_as );

  around same_identity_as => sub ($orig, $self, $t) {
    if ( ref $self ne ref $t ) {
      carp 'Argument type ' . ref $t . 'is invalid.'
        . '(It must be ' . ref $self . '.';
    }
    $self->$orig($t);
  };

}

1;

__END__

=encoding utf8

=head1 NAME

DDDPractice::Domain::Model::Role::Entity - EntityのRole

=head1 SYNOPSIS
  
  with 'DDDPractice::Domain::Model::Role::Entity';
  ...

=head1 DESCRIPTION

Entityを実装するときは必ずこのRoleを消費してください。

=head1 METHODS

=head2 same_identity_as(value: T): Bool

引数として同じ型の値を1つ受け取ります。
引数の値と `$self` が同じ値かどうかを調べるメソッドの実装を期待しています。

=cut

