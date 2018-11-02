package DDDPractice::App::User::UserService {

  use Mouse;
  use DDDPractice::Exporter;
  use Scalish qw( left right );
  use namespace::autoclean;

  use aliased 'DDDPractice::Domain::User::RegistrationRule';
  use aliased 'DDDPractice::Domain::User::FullName';
  use aliased 'DDDPractice::Domain::User::User';
  use aliased 'DDDPractice::Domain::User::UserID';
  use aliased 'DDDPractice::App::User::UserModel';

  has unit_of_work => (
    is       => 'ro',
    does     => 'DDDPractice::Domain::User::UnitOfWork',
    handles  => [qw( user_repository )],
    required => 1,
  );

  has registration_rule => (
    is      => 'ro',
    isa     => RegistrationRule,
    lazy    => 1,
    builder => '_build_registration_rule',
  );

  sub _build_registration_rule($self) {
    RegistrationRule->new(user_repository => $self->user_repository);
  }

  sub regist_user($self, $first_name, $family_name) {
    $self->unit_of_work->begin;
    my $full_name = FullName->new(
      first_name  => $first_name,
      family_name => $family_name,
    );
    my $user = User->new(full_name => $full_name);
    if ( $self->registration_rule->is_duplicated($user) ) {
      $self->unit_of_work->rollback;
      left '同じIDのユーザーがいます';
    }
    else {
      $self->user_repository->save($user);
      $self->unit_of_work->commit;
      right 'ユーザー登録成功';
    }
  }

  sub change_user_info($self, $id, $first_name, $family_name) {
    $self->unit_of_work->begin;
    my $target_id    = UserID->new(value => $id);
    my $maybe_target = $self->user_repository->find($target_id);
    $maybe_target->match(
      Some => sub ($target) {
        my $new_name = FullName->new(
          first_name  => $first_name,
          family_name => $family_name,
        );
        $target->full_name($new_name);
        $self->user_repository->save($target);
        $self->unit_of_work->commit;
        right 'ユーザー情報変更成功';
      },
      None => sub {
        $self->unit_of_work->rollback;
        left "id : $id のユーザーはいませんでした";
      },
    );
  }
  
  sub remove_user($self, $id) {
    $self->unit_of_work->begin;
    my $target_id    = UserID->new(value => $id);
    my $maybe_target = $self->user_repository->find($target_id);
    $maybe_target->match(
      Some => sub ($target) {
        $self->user_repository->remove($target);
        $self->unit_of_work->commit;
        right 'ユーザー削除成功';
      },
      None => sub {
        $self->unit_of_work->rollback;
        left "id : $id のユーザーはいませんでした";
      },
    );
  }

  sub get_user_info($self, $id) {
    my $target_id    = UserID->new(value => $id);
    my $maybe_target = $self->user_repository->find($target_id);
    $maybe_target->map(sub ($target) { UserModel->new(source => $target) } );
  }

  sub get_user_list($self) {
    my $users = $self->user_repository->find_all;
    [ map { UserModel->new(source => $_) } @$users ];
  }

  __PACKAGE__->meta->make_immutable;

}

1;
