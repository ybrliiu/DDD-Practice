package DDDPractice::App::User::UserModel {

  use Mouse;
  use DDDPractice::Exporter;
  use namespace::autoclean;

  use aliased 'DDDPractice::App::User::FullNameModel';

  has source => (
    is       => 'bare',
    isa      => 'DDDPractice::Domain::User::User',
    required => 1,
  );

  has id => (
    is       => 'ro',
    isa      => 'Str',
    init_arg => undef,
  );

  has full_name => (
    is       => 'ro',
    isa      => FullNameModel,
    init_arg => undef,
  );

  sub BUILD($self, $args) {
    my $source         = $self->{source};
    $self->{id}        = $source->id->value;
    my $full_name      = FullNameModel->new(source => $source->full_name);
    $self->{full_name} = $full_name;
  }

  __PACKAGE__->meta->make_immutable;

}

1;
