package DDDPractice::Container {

  use Mouse;
  use Bread::Board;
  use DDDPractice::Exporter;
  use namespace::autoclean;

  extends 'Bread::Board::Container';

  sub instance($self) {
    state $singleton = $self;
  }

  sub BUILD($self, $args) {

    container Infrastructure => as {

      container User => as {

        service in_memory_user_repository => (
          block => sub ($s) {
            require DDDPractice::Infrastructure::User::UserRepository;
            DDDPractice::Infrastructure::User::UserRepository->new;
          },
          lifecycle => 'Singleton',
        );

      };

    };

  }

  __PACKAGE__->meta->make_immutable;

}

1;
