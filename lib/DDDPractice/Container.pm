package DDDPractice::Container {

  use Mouse;
  use Bread::Board;
  use DDDPractice::Exporter;
  use namespace::autoclean;

  use DDDPractice::Infrastructure::InMemory::User::UnitOfWork;
  use DDDPractice::Infrastructure::InMemory::User::UserRepository;
  use DDDPractice::Infrastructure::Storable::User::UnitOfWork;
  use DDDPractice::Infrastructure::Storable::User::UserRepository;

  extends 'Bread::Board::Container';

  has name => (
    is      => 'ro',
    isa     => 'Str',
    default => 'ddd_practice',
  );

  sub instance($class) {
    state $singleton = $class->new;
  }

  sub BUILD($self, $args) {

    my $container = container Infrastructure => as {

      container User => as {

        service in_memory_unit_of_work => (
          block => sub ($s) {
            DDDPractice::Infrastructure::InMemory::User::UnitOfWork->new(
              user_repository => $s->param('user_repository'),
            );
          },
          dependencies => +{
            user_repository => 'in_memory_user_repository',
          },
        );

        service in_memory_user_repository => (
          block => sub ($s) {
            DDDPractice::Infrastructure::InMemory::User::UserRepository->new;
          },
        );

        service storable_unit_of_work => (
          block => sub ($s) {
            DDDPractice::Infrastructure::Storable::User::UnitOfWork->new(
              user_repository => $s->param('user_repository'),
            );
          },
          dependencies => +{
            user_repository => 'storable_user_repository',
          },
        );

        service storable_user_repository => (
          block => sub ($s) {
            DDDPractice::Infrastructure::Storable::User::UserRepository->new;
          },
        );

      };

    };

    $self->add_sub_container($container);
  }

  __PACKAGE__->meta->make_immutable;

}

1;
