package DDDPractice::Infrastructure::InMemory::User::UnitOfWork {

  use Mouse;
  use DDDPractice::Exporter;
  use namespace::autoclean;

  with 'DDDPractice::Domain::User::UnitOfWork';

  has '+user_repository' => (
    isa => 'DDDPractice::Infrastructure::InMemory::User::UserRepository',
  );

  sub begin($self) {
    $self->user_repository->begin;
  }
  
  sub commit($self) {
    $self->user_repository->commit;
  }

  sub rollback($self) {
    $self->user_repository->rollback;
  }

  __PACKAGE__->meta->make_immutable;

}

1;
