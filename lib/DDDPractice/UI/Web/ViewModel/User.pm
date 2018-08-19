package DDDPractice::UI::Web::ViewModel::User {

  use Mouse;
  use DDDPractice::Exporter;
  use namespace::autoclean;

  has id => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
  );

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

  __PACKAGE__->meta->make_immutable;

}

1;
