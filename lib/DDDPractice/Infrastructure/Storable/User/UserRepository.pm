package DDDPractice::Infrastructure::Storable::User::UserRepository {

  use Mouse;
  use DDDPractice::Exporter;
  use Scalish qw( option right left );
  use Storable qw( retrieve store );
  use namespace::autoclean;

  with 'DDDPractice::Domain::User::UserRepository';

  use constant FILE_NAME => './user.dat';

  has memory => (
    is      => 'ro',
    isa     => 'HashRef[DDDPractice::Domain::User::User]',
    builder => '_build_memory',
  );

  sub _build_memory($self) {
    retrieve( FILE_NAME );
  }

  sub find($self, $user_id) {
    option $self->memory->{ $user_id->value };
  }

  sub find_all($self) {
    [ values $self->memory->%* ];
  }

  sub save($self, $user) {
    $self->memory->{ $user->id->value } = $user;
    store $self->memory, FILE_NAME;
    right 'ユーザーデータの保存に成功';
  }

  sub remove($self, $user) {
    delete $self->memory->{ $user->id->value }
      ? right 'ユーザーデーターの削除に成功'
      : left 'ユーザーデーターの削除に失敗';
  }

  __PACKAGE__->meta->make_immutable;

}

1;
