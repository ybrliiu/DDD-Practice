package DDDPractice::UI::Web::Controller::Root {

  use Mojo::Base 'Mojolicious::Controller';
  use DDDPractice::Exporter;
  use namespace::autoclean;

  use aliased 'DDDPractice::Container';
  use aliased 'DDDPractice::App::User::UserService';
  use aliased 'DDDPractice::UI::Web::ViewModel::User';

  has container => sub ($self) { Container->instance };

  has user_service => sub ($self) {
    my $user_repository =
      $self->container->fetch('Infrastructure/User/in_memory_user_repository')->get;
    UserService->new(user_repository => $user_repository);
  };

  sub root($self) {
    $self->render(msg => 'Welcome to DDDPractice App!!');
  }

  sub user_list($self) {
    my @users = map {
      User->new(
        id         => $_->id,
        first_name => $_->first_name,
        full_name  => $_->full_name,
      );
    } $self->user_service->get_user_list->@*;
    $self->render(users => \@users);
  }

  sub user_info($self) {
  }

  sub remove_user($self) {
  }

  sub user_register($self) {
    $self->render;
  }

  sub regist_user($self) {
  }

}

1;
