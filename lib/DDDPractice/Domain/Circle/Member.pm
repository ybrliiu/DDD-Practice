package DDDPractice::Domain::Circle::Member {

  use Mouse;
  use DDDPractice::Exporter;
  use namespace::autoclean;

  with 'DDDPractice::Domain::Role::ValueObject';

  has user_id => (
    is       => 'ro',
    isa      => 'DDDPractice::Domain::User::UserID',
    required => 1,
  );

  sub same_value_as($self, $member) {
    $self->user_id->same_value_as( $member->user_id );
  }

  __PACKAGE__->meta->make_immutable;

}

1;
