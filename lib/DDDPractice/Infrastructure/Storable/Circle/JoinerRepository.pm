package DDDPractice::Infrastructure::Storable::Circle::JoinerRepository {

  use Mouse;
  use DDDPractice::Exporter;
  use namespace::autoclean;

  use aliased 'DDDPractice::Domain::User::UserID';
  use aliased 'DDDPractice::Domain::Circle::Joiner';
  use aliased 'DDDPractice::Infrastructure::Storable::UserDataStore';

  with 'DDDPractice::Domain::Circle::JoinerRepository';

  has store => (
    is       => 'ro',
    isa      => UserDataStore,
    init_arg => undef,
    builder  => '_build_store',
  );

  sub _build_store($self) {
    UserDataStore->new;
  }

  sub _user_data_to_joiner($class, $user_data) {
    Joiner->new( user_id => UserID->new( value => $user_data->id ) );
  }

  sub find($self, $user_id) {
    $self->store->get( $user_id->value )->map(sub ($user_data) {
      $self->_user_data_to_joiner($user_data);
    });
  }

  __PACKAGE__->meta->make_immutable;

}

1;
