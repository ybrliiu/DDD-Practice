package DDDPractice::App::User::FullNameModel {

  use Mouse;
  use DDDPractice::Exporter;
  use namespace::autoclean;

  has source => (
    is       => 'bare',
    isa      => 'DDDPractice::Domain::User::FullName',
    required => 1,
  );

  has first_name => (
    is       => 'ro',
    isa      => 'Str',
    init_arg => undef,
  );

  has full_name => (
    is       => 'ro',
    isa      => 'Str',
    init_arg => undef,
  );

  sub BUILD($self, $args) {
    $self->first_name( $self->{source}->first_name );
    $self->full_name( $self->{source}->full_name );
  }

  __PACKAGE__->meta->make_immutable;

}

1;
