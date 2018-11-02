package DDDPractice::Infrastructure::Storable::UserDataStore {

  use Mouse;
  use DDDPractice::Exporter;
  use namespace::autoclean;

  use Try::Tiny;
  use Fcntl qw( :flock );
  use Scalish qw( option right left );
  use Storable qw( retrieve fd_retrieve nstore nstore_fd );

  use constant FILE_NAME => './user_data.dat';

  has _is_transactioning => (
    is       => 'rw',
    isa      => 'Bool',
    init_arg => undef,
    default  => 0,
  );

  has _maybe_memory => (
    is       => 'rw',
    isa      => 'Maybe[HashRef[DDDPractice::Infrastructure::Storable::UserData]]',
    init_arg => undef,
    default  => undef,
  );

  has _maybe_fh => (
    is       => 'rw',
    isa      => 'Maybe[FileHandle]',
    init_arg => undef,
    default  => undef,
  );

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

  sub _read($self) {
    try {
      retrieve $self->FILE_NAME;
    } catch {
      my $e = $_;
      if ($e =~ /can't open (??{ $self->FILE_NAME })/) {
        nstore +{}, $self->FILE_NAME;
        retrieve $self->FILE_NAME;
      }
      else {
        die $e;
      }
    };
  }

  sub get($self, $id) {
    my $maybe_user_data = do {
      if ( $self->_is_transactioning ) {
        $self->_maybe_memory->{$id};
      }
      else {
        $self->_read->{$id};
      }
    };
    option $maybe_user_data;
  }

  sub get_all($self) {
    $self->_is_transactioning ? [ values $self->_maybe_memory->%* ] : [ values $self->_read->%* ];
  }

  sub set($self, $user_data) {
    my $is_success = do {
      if ( $self->_is_transactioning ) {
        $self->_maybe_memory->{ $user_data->id } = $user_data;
      }
      else {
        my $memory = $self->_read;
        $memory->{ $user_data->id } = $user_data;
        nstore $memory, $self->FILE_NAME;
      }
    };
    $is_success
      ? right 'ユーザーデータの保存に成功'
      : left "ユーザーデータの保存に失敗 : $!";
  }

  sub delete($self, $id) {
    my $is_success = do {
      if ( $self->_is_transactioning ) {
        delete $self->_maybe_memory->{$id}
      }
      else {
        my $memory = $self->_read;
        my $is_delete_success = delete $memory->{$id};
        $is_delete_success ? nstore($memory, $self->FILE_NAME) : $is_delete_success;
      }
    };
    $is_success
      ? right 'ユーザーデーターの削除に成功'
      : left "ユーザーデータの削除に失敗 : $!";
  }

  sub DEMOLISH($self, @) {
    $self->rollback if $self->_is_transactioning;
  }

  __PACKAGE__->meta->make_immutable;

}

1;
