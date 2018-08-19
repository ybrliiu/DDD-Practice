package DDDPractice::Domain::User::UserRepository {

  use Mouse::Role;
  use DDDPractice::Exporter;

  requires 'find';

  requires 'find_all';

  requires 'save';

  requires 'remove';

}

1;
