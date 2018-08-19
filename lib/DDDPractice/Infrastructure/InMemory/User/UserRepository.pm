package DDDPractice::Infrastructure::User::UserRepository {

  use Mouse;
  use DDDPractice::Exporter;
  use Scalish qw( option right left );
  use namespace::autoclean;

  with 'DDDPractice::Domain::User::UserRepository';

  has memory => (
    is      => 'ro',
    isa     => 'HashRef[DDDPractice::Domain::User::User]',
    default => sub { +{} },
  );

  sub find($self, $user_id) {
    option $self->memory->{ $user_id->value };
  }

  sub find_all($self) {
    [ values $self->memory->%* ];
  }

  sub save($self, $user) {
    $self->memory->{ $user->id->value } = $user;
    right 'ユーザーデータの保存に成功'
  }

  sub remove($self, $user) {
    delete $self->memory->{ $user->id->value }
      ? right 'ユーザーデーターの削除に成功'
      : left 'ユーザーデーターの削除に失敗';
  }

  __PACKAGE__->meta->make_immutable;

}

1;
