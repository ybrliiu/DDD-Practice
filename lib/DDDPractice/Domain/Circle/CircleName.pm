package DDDPractice::Domain::Circle::CircleName {

  use Mouse;
  use DDDPractice::Exporter;
  use namespace::autoclean;

  with 'DDDPractice::Domain::Role::ValueObject';

  has value => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
  );

  sub same_value_as($self, $name) {
    $self->value == $name->value;
  }

  __PACKAGE__->meta->make_immutable;

}

1;
