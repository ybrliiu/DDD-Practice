package DDDPractice::Domain::Circle::Members {

  use Mouse;
  use DDDPractice::Exporter;
  use namespace::autoclean;

  use Array::Diff;

  with 'DDDPractice::Domain::Role::ValueObject';

  has contents => (
    is       => 'ro',
    isa      => 'ArrayRef[DDDPractice::Domain::Circle::Member]',
    required => 1,
  );

  sub add($self, $member) {
    push $self->contents->@*, $member;
  }

  sub size($self) {
    scalar $self->contents->@*;
  }

  sub as_array_ref($self) {
    $self->contents;
  }

  sub as_value($self) {
    [ map { $_->name } sort { $a->name cmp $b->name } $self->contents->@* ];
  }

  sub same_value_as($self, $members) {
    my $diff = Array::Diff->diff( $self->as_value, $members->as_value );
    $diff->count == 0;
  }

  __PACKAGE__->meta->make_immutable;

}

1;
