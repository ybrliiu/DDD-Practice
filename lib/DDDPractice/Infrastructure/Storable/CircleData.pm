package DDDPractice::Infrastructure::Storable::CircleData {

  use Mouse;
  use DDDPractice::Exporter;
  use namespace::autoclean;

  has id => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
  );

  has name => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
  );

  has members_ids => (
    is       => 'ro',
    isa      => 'ArrayRef[Str]',
    required => 1,
  );

  sub new_from_user_model($class, $user) {
    $class->new(
      id          => $user->id->value,
      first_name  => $user->full_name->first_name,
      family_name => $user->full_name->family_name,
    );
  }

  __PACKAGE__->meta->make_immutable;

}

1;
