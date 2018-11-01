package DDDPractice::Domain::User::CircleID {

  use Mouse;
  use DDDPractice::Exporter;
  use namespace::autoclean;

  use Data::GUID;

  with 'Rinne::Domain::Role::Entity';

  has value => (
    is      => 'ro',
    isa     => 'Data::GUID',
    lazy    => 1,
    builder => '_build_value',
    handles => [qw( as_string )],
  );

  sub _build_value($self) {
    Data::GUID->new;
  }

  sub same_identity_as($self, $id) {
    $self->as_string eq $id->as_string;
  }

  __PACKAGE__->meta->make_immutable;

}

1;
