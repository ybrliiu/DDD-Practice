package DDDPractice::Infrastructure::InMemory::User::UserRepository {

  use Mouse;
  use DDDPractice::Exporter;
  use namespace::autoclean;

  use Scalish qw( option right left );
  use Storable qw( dclone );

  with 'DDDPractice::Domain::User::UserRepository';

  my $Is_locking = 0;

  # isa => 'HashRef[DDDPractice::Domain::User::User]'
  my $Memory = +{};

  has _is_transactioning => (
    is       => 'rw',
    isa      => 'Bool',
    init_arg => undef,
    default  => 0,
  );

  has _be_operated_memory => (
    is      => 'rw',
    isa     => 'Maybe[HashRef[DDDPractice::Domain::User::User]]',
    default => undef,
  );

  sub begin($self) {
    return if $self->_is_transactioning;
    if ( $Is_locking ) {
      sleep 1;
      $self->begin;
    }
    else {
      $Is_locking = 1;
      $self->_is_transactioning(1);
      $self->_be_operated_memory( dclone $Memory );
    }
  }

  sub commit($self) {
    $Memory = $self->_be_operated_memory;
    $self->_unlock;
  }

  sub rollback($self) {
    $self->_unlock;
  }

  sub _unlock($self) {
    $self->_be_operated_memory(undef);
    $self->_is_transactioning(0);
    $Is_locking = 0;
  }

  sub find($self, $user_id) {
    option $Memory->{ $user_id->value };
  }

  sub find_all($self) {
    [ values %$Memory ];
  }

  sub save($self, $user) {
    $Memory->{ $user->id->value } = $user;
    right 'ユーザーデータの保存に成功'
  }

  sub remove($self, $user) {
    delete $Memory->{ $user->id->value }
      ? right 'ユーザーデーターの削除に成功'
      : left 'ユーザーデーターの削除に失敗';
  }

  sub DEMOLISH($self, @) {
    $self->rollback if $self->_is_transactioning;
  }

  __PACKAGE__->meta->make_immutable;

}

1;
