package DDDPractice::Domain::Circle::Circle {

  use Mouse;
  use DDDPractice::Exporter;
  use namespace::autoclean;

  use aliased 'DDDPractice::Domain::Circle::Member';

  with 'DDDPractice::Domain::Role::Entity';

  has id => (
    is       => 'ro',
    isa      => 'DDDPractice::Domain::Circle::CircleID',
    required => 1,
  );

  has name => (
    is       => 'rw',
    isa      => 'DDDPractice::Domain::Circle::CircleName',
    required => 1,
  );

  has members => (
    is       => 'ro',
    isa      => 'DDDPractice::Domain::Circle::Members',
    required => 1,
  );

  sub same_identity_as($self, $circle) {
    $self->id->same_value_as( $circle->id );
  }

  sub join($self, $joiner) {
    my $member = Member->new( user_id => $joiner->user_id );
    $self->members->add($member);
  }

}

1;
