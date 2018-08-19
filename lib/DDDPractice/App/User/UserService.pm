package DDDPractice::App::User::UserService {

  use Mouse;
  use DDDPractice::Exporter;
  use Scalish qw( right left );
  use namespace::autoclean;

  use aliased 'DDDPractice::Domain::User::RegistrationRule';
  use aliased 'DDDPractice::Domain::User::FullName';
  use aliased 'DDDPractice::Domain::User::User';
  use aliased 'DDDPractice::Domain::User::UserID';
  use aliased 'DDDPractice::App::User::UserModel';

  has user_repository => (
    is       => 'ro',
    does     => 'DDDPractice::Domain::User::UserRepository',
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
    my $full_name = FullName->new(
      first_name  => $first_name,
      family_name => $family_name,
    );
    my $user = User->new(full_name => $full_name);
    if ( $self->registration_rule->is_duplicated($user) ) {
      left '同じIDのユーザーがいます';
    }
    else {
      $self->user_repository->save($user);
      right '登録成功';
    }
  }

  sub change_user_info($self, $id, $first_name, $family_name) {
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
        right '名前の変更に成功しました';
      },
      None => sub {
        left "id : $id のユーザーはいませんでした";
      },
    );
  }
  
  sub remove_user($self, $id) {
    my $target_id    = UserID->new(value => $id);
    my $maybe_target = $self->user_repository->find($target_id);
    $maybe_target->match(
      Some => sub ($target) {
        $self->user_repository->remove($target);
        right 'ユーザーの削除に成功しました';
      },
      None => sub {
        left "id : $id のユーザーはいませんでした";
      },
    );
  }

  sub get_user_info($self, $id) {
    my $target_id    = UserID->new(value => $id);
    my $maybe_target = $self->user_repository->find($target_id);
    $maybe_target->match(
      Some => sub ($target) {
        my $target_model = UserModel->new(source => $target);
        right $target_model;
      },
      None => sub {
        left "id : $id のユーザーはいませんでした";
      },
    );
  }

  sub get_user_list($self) {
    my $users = $self->user_repository->find_all;
    [ map { UserModel->new(source => $_) } @$users ];
  }

  __PACKAGE__->meta->make_immutable;

}

1;
