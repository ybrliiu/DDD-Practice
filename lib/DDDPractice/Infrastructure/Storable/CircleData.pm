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

  sub new_from_circle_model($class, $circle) {
    my @members_ids = map { $_->user_id->value } $circle->members->@*;
    $class->new(
      id          => $circle->id->value,
      name        => $circle->name->value,
      members_ids => \@members_ids,
    );
  }

  __PACKAGE__->meta->make_immutable;

}

1;
