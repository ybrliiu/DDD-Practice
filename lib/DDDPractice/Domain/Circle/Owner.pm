package DDDPractice::Domain::Circle::Owner {

  use Mouse;
  use DDDPractice::Exporter;
  use namespace::autoclean;

  with 'DDDPractice::Domain::Role::Entity';

  has user_id => (
    is       => 'ro',
    isa      => 'DDDPractice::Domain::User::UserID',
    required => 1,
  );

  sub same_identity_as($self, $owner) {
    $self->user_id->same_value_as( $owner->user_id );
  }

  __PACKAGE__->meta->make_immutable;

}

1;
