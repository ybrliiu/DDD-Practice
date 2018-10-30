package DDDPractice::Container {

  use Mouse;
  use Bread::Board;
  use DDDPractice::Exporter;
  use namespace::autoclean;

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

        service in_memory_user_repository => (
          block => sub ($s) {
            require DDDPractice::Infrastructure::InMemory::User::UserRepository;
            DDDPractice::Infrastructure::InMemory::User::UserRepository->new;
          },
          lifecycle => 'Singleton',
        );

        service storable_user_repository => (
          block => sub ($s) {
            require DDDPractice::Infrastructure::Storable::User::UserRepository;
            DDDPractice::Infrastructure::Storable::User::UserRepository->new;
          },
          lifecycle => 'Singleton',
        );

      };

    };

    $self->add_sub_container($container);
  }

  __PACKAGE__->meta->make_immutable;

}

1;
