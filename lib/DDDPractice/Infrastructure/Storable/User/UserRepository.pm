package DDDPractice::Infrastructure::Storable::User::UserRepository {

  use Mouse;
  use DDDPractice::Exporter;
  use namespace::autoclean;

  use Try::Tiny;
  use Fcntl qw( :flock );
  use Scalish qw( option right left );
  use Storable qw( retrieve nstore fd_retrieve );

  with 'DDDPractice::Domain::User::UserRepository';

  use constant FILE_NAME => './user.dat';

  has _is_transactioning => (
    is       => 'rw',
    isa      => 'Bool',
    init_arg => undef,
    default  => 0,
  );

  has _maybe_memory => (
    is       => 'rw',
    isa      => 'Maybe[HashRef[DDDPractice::Domain::User::User]]',
    init_arg => undef,
    default  => undef,
  );

  has _maybe_fh => (
    is       => 'rw',
    isa      => 'Maybe[FileHandle]',
    init_arg => undef,
    default  => undef,
  );

  sub _read($self) {
    try {
      retrieve $self->FILE_NAME;
    } catch {
      my $e = $_;
      if ($e =~ /can't open (??{ $self->FILE_NAME })/) {
        nstore(+{}, $self->FILE_NAME);
        retrieve $self->FILE_NAME;
      }
      else {
        die $e;
      }
    };
  }

  sub begin($self) {
    return if $self->_is_transactioning;
    $self->_is_transactioning(1);
    open my $fh, '+<', $self->FILE_NAME or die $!;
    flock $fh, LOCK_EX or die $!;
    $self->_maybe_fh($fh);
    $self->_maybe_memory(fd_retrieve $fh);
  }

  sub commit($self) {
    truncate $self->_maybe_fh, 0 or die $!;
    seek $self->_maybe_fh, 0, 0 or die $!;
    nstore_fd( $self->_maybe_memory, $self->_maybe_fh );
    $self->_unlock;
  }

  sub rollback($self) {
    $self->_unlock;
  }

  sub _unlock($self) {
    $self->_maybe_fh->close;
    $self->_maybe_memory(undef);
    $self->_maybe_fh(undef);
    $self->_is_transactioning(0);
  }

  sub find($self, $user_id) {
    my $memory = $self->_read;
    option $memory->{ $user_id->value };
  }

  sub find_all($self) {
    my $memory = $self->_read;
    [ values $memory->%* ];
  }

  sub save($self, $user) {
    my $is_success = do {
      if ( $self->_is_transactioning ) {
        $self->_maybe_memory->{ $user->id->value } = $user;
      }
      else {
        my $memory = $self->_read;
        $memory->{ $user->id->value } = $user;
        nstore $memory, $self->FILE_NAME;
      }
    };
    $is_success
      ? right 'ユーザーデータの保存に成功'
      : left "ユーザーデータの保存に失敗 : $!";
  }

  sub remove($self, $user) {
    my $is_success = do {
      if ( $self->_is_transactioning ) {
        delete $self->_maybe_memory->{ $user->id->value }
      }
      else {
        my $memory = $self->_read;
        my $is_delete_success = delete $memory->{ $user->id->value };
        if ( $is_delete_success ) {
          nstore($memory, $self->FILE_NAME) or die $!;
        }
        $is_delete_success;
      }
    };
    $is_success
      ? right 'ユーザーデーターの削除に成功'
      : left "ユーザーデータの保存に失敗 : $!";
  }

  sub DEMOLISH($self, @) {
    $self->rollback if $self->_is_transactioning;
  }

  __PACKAGE__->meta->make_immutable;

}

1;
