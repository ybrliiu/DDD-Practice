package DDDPractice::Domain::User::FullName {

  use Mouse;
  use DDDPractice::Exporter;
  use namespace::autoclean;

  with 'DDDPractice::Domain::Role::ValueObject';

  has first_name => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
  );

  has family_name => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
  );

  sub same_value_as($self, $full_name) {
    $self->first_name eq $full_name->first_name && $self->family_name eq $full_name->family_name;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

