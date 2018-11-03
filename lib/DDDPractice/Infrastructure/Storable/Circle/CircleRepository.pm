package DDDPractice::Infrastructure::Storable::Circle::CircleRepository {

  use Mouse;
  use DDDPractice::Exporter;
  use namespace::autoclean;

  use aliased 'DDDPractice::Domain::Circle::Circle';
  use aliased 'DDDPractice::Domain::Circle::CircleID';
  use aliased 'DDDPractice::Domain::Circle::CircleName';
  use aliased 'DDDPractice::Domain::Circle::Member';
  use aliased 'DDDPractice::Domain::Circle::Members';
  use aliased 'DDDPractice::Infrastructure::Storable::CircleData';
  use aliased 'DDDPractice::Infrastructure::Storable::CircleDataStore';

  with 'DDDPractice::Domain::Circle::CircleRepository';

  has store => (
    is       => 'ro',
    isa      => CircleDataStore,
    init_arg => undef,
    builder  => '_build_store',
  );

  sub _build_store($self) {
    CircleDataStore->new;
  }

  sub begin($self) {
    $self->store->begin;
  }

  sub commit($self) {
    $self->store->commit;
  }

  sub rollback($self) {
    $self->store->rollback;
  }

  sub _circle_data_to_circle($class, $circle_data) {

    my @members = map {
      my $member_id = $_;
      my $user_id = UserID->new( value => $member_id );
      Member->new( user_id => $user_id );
    } $circle_data->members_ids->@*;

    Circle->new(
      id      => CircleID->new( value => $circle_data->id ),
      name    => CircleName->new( value => $circle_data->name ),
      members => Members->new( contents => \@members ),
    );
  }

  sub find($self, $circle_id) {
    $self->store->get( $circle_id->value )->map(sub ($circle_data) {
      $self->_circle_data_to_circle($circle_data);
    });
  }

  sub find_all($self) {
    [ map { $self->_circle_data_to_circle($_) } $self->store->get_all->@* ];
  }

  sub save($self, $circle) {
    $self->store->set( CircleData->new_from_circle_model($circle) );
  }

  sub remove($self, $circle) {
    $self->store->delete( $circle->id->value );
  }

  __PACKAGE__->meta->make_immutable;

}

1;
