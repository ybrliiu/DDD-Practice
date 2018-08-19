package DDDPractice::Domain::User::User {

  use Mouse;
  use DDDPractice::Exporter;

  with 'DDDPractice::Domain::Role::Entity';

  has id => (
    is       => 'ro',
    isa      => 'DDDPractice::Domain::Model::User::UserID',
    required => 1,
  );

  has name => (
    is       => 'rw',
    isa      => 'DDDPractice::Domain::Model::User::FullName',
    required => 1,
  );

  sub same_identity_as($self, $user) {
    $self->id->same_value_as( $user->id );
  }

  __PACKAGE__->meta->make_immutable;

}

1;
