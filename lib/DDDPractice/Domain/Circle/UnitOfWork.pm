package DDDPractice::Domain::Circle::UnitOfWork {

  use Mouse::Role;
  use DDDPractice::Exporter;
  use namespace::autoclean;

  has circle_repository => (
    is       => 'ro',
    isa      => 'DDDPractice::Domain::Circle::CircleRepository',
    required => 1,
  );

  has joiner_repository => (
    is       => 'ro',
    isa      => 'DDDPractice::Domain::Circle::JoinerRepository',
    required => 1,
  );

  has owner_repository => (
    is       => 'ro',
    isa      => 'DDDPractice::Domain::Circle::OwnerRepository',
    required => 1,
  );

  requires 'begin';

  requires 'commit';

  requires 'rollback';

}

1;
