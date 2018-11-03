package DDDPractice::Infrastructure::Storable::Circle::UnitOfWork {

  use Mouse;
  use DDDPractice::Exporter;
  use namespace::autoclean;

  with 'DDDPractice::Domain::Circle::UnitOfWork';

  has '+circle_repository' => (
    isa => 'DDDPractice::Infrastructure::Storable::Circle::CircleRepository',
  );

  has '+joiner_repository' => (
    isa => 'DDDPractice::Infrastructure::Storable::Circle::JoinerRepository',
  );

  has '+owner_repository' => (
    isa => 'DDDPractice::Infrastructure::Storable::Circle::OwnerRepository',
  );

  sub begin($self) {
    $self->circle_repository->begin;
  }
  
  sub commit($self) {
    $self->circle_repository->commit;
  }

  sub rollback($self) {
    $self->circle_repository->rollback;
  }

  __PACKAGE__->meta->make_immutable;

}

1;
