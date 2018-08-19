package DDDPractice::Domain::User::UserRepository {

  use Mouse::Role;
  use DDDPractice::Exporter;
  use namespace::autoclean;

  requires 'find';

  requires 'find_all';

  requires 'save';

  requires 'remove';

}

1;
