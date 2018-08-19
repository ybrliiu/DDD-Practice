package DDDPractice::Domain::User::User {

  use Mouse;
  use DDDPractice::Exporter;
  use namespace::autoclean;

  use Data::GUID;
  use aliased 'DDDPractice::Domain::User::UserID';

  with 'DDDPractice::Domain::Role::Entity';

  has id => (
    is      => 'ro',
    isa     => UserID,
    builder => '_build_id',
  );

  has name => (
    is       => 'rw',
    isa      => 'DDDPractice::Domain::Model::User::FullName',
    required => 1,
  );

  sub _build_id($self) {
    my $value = Data::GUID->new->as_string;
    UserID->new(value => $value);
  }

  sub same_identity_as($self, $user) {
    $self->id->same_value_as( $user->id );
  }

  __PACKAGE__->meta->make_immutable;

}

1;
