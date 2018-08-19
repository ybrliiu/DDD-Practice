package DDDPractice::Domain::Model::User::UserID {

  use Mouse;
  use DDDPractice::Exporter;

  with 'DDDPractice::Domain::Role::ValueObject';

  has value => (
    is       => 'ro',
    isa      => 'Int',
    required => 1,
  );

  sub same_value_as($self, $user_id) {
    $self->value == $user_id->value;
  }

  __PACKAGE__->meta->make_immutable;

}

1;
