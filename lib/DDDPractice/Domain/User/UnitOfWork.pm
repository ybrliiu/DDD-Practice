package DDDPractice::Domain::User::UnitOfWork {

  use Mouse::Role;
  use DDDPractice::Exporter;
  use namespace::autoclean;

  has user_repository => (
    is       => 'ro',
    isa      => 'DDDPractice::Domain::User::UserRepository',
    required => 1,
  );

  requires 'begin';

  requires 'commit';

  requires 'rollback';

}

1;
