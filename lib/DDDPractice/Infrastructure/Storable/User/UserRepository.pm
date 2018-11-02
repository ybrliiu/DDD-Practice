package DDDPractice::Infrastructure::Storable::User::UserRepository {

  use Mouse;
  use DDDPractice::Exporter;
  use namespace::autoclean;

  use aliased 'DDDPractice::Domain::User::User';
  use aliased 'DDDPractice::Domain::User::UserID';
  use aliased 'DDDPractice::Domain::User::FullName';
  use aliased 'DDDPractice::Infrastructure::Storable::UserData';
  use aliased 'DDDPractice::Infrastructure::Storable::UserDataStore';

  with 'DDDPractice::Domain::User::UserRepository';

  has store => (
    is       => 'ro',
    isa      => UserDataStore,
    init_arg => undef,
    builder  => '_build_store',
  );

  sub _build_store($self) {
    UserDataStore->new;
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

  sub _user_data_to_user($class, $user_data) {
    User->new(
      id        => UserID->new( value => $user_data->id ),
      full_name => FullName->new(
        first_name  => $user_data->first_name,
        family_name => $user_data->family_name,
      ),
    );
  }

  sub find($self, $user_id) {
    $self->store->get( $user_id->value )->map(sub ($user_data) {
      $self->_user_data_to_user($user_data);
    });
  }

  sub find_all($self) {
    [ map { $self->_user_data_to_user($_) } $self->store->get_all->@* ];
  }

  sub save($self, $user) {
    $self->store->set( UserData->new_from_user_model($user) );
  }

  sub remove($self, $user) {
    $self->store->delete( $user->id->value );
  }

  __PACKAGE__->meta->make_immutable;

}

1;
