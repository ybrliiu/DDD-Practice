package DDDPractice::Domain::User::RegistrationRule {

  use Mouse;
  use DDDPractice::Exporter;
  use namespace::autoclean;

  has user_repository => (
    is       => 'ro',
    # does     => 'DDDPractice::Domain::User::UserRepository',
    required => 1,
  );

  sub is_duplicated($self, $user) {
    $self->user_repository->find( $user->id )->is_defined;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

