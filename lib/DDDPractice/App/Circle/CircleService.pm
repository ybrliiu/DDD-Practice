package DDDPractice::App::Circle::CircleService {

  use Mouse;
  use DDDPractice::Exporter;
  use Scalish qw( right left for_yield );
  use namespace::autoclean;

  use aliased 'DDDPractice::Domain::User::UserID';
  use aliased 'DDDPractice::Domain::Circle::CircleID';
  use aliased 'DDDPractice::Domain::Circle::CircleName';

  has unit_of_work => (
    is       => 'ro',
    does     => 'DDDPractice::Domain::Circle::UnitOfWork',
    handles  => [qw( circle_repository joiner_repository owner_repository )],
    required => 1,
  );

  sub create_circle($self, $user_id, $circle_name) {
    my $owner_id = UserID->new( value => $user_id );
    $self->owner_repository->find($owner_id)->match(
      Some => sub ($owner) {
        $self->unit_of_work->begin;
        my $circle_name = CircleName->new( value => $circle_name );
        my $circle      = $owner->create_circle($circle_name);
        $self->circle_repository->save($circle);
        $self->unit_of_work->commit;
        right 'サークル登録成功';
      },
      None => sub { left 'サークル登録失敗' },
    );
  }

  sub join_user($self, $circle_id, $user_id) {
    my $join_circle_id = CircleID->new( value => $circle_id );
    my $maybe_circle   = $self->circle_repository->find($join_circle_id);
    my $joiner_id      = UserID->new( value => $user_id );
    my $maybe_joiner   = $self->joiner_repository->find($joiner_id);
    for_yield [ $maybe_circle, $maybe_joiner ], sub ($circle, $joiner) {
      $self->unit_of_work->begin;
      $circle->join($joiner);
      $self->circle_repository->save($circle);
      $self->unit_of_work->commit;
    };
  }

  __PACKAGE__->meta->make_immutable;

}

1;
