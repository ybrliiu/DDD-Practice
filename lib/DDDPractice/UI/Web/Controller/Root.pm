package DDDPractice::UI::Web::Controller::Root {

  use Mojo::Base 'Mojolicious::Controller';
  use DDDPractice::Exporter;
  use Scalish qw( option for_yield );
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
        id          => $_->id,
        first_name  => $_->full_name->first_name,
        family_name => $_->full_name->family_name,
      );
    } $self->user_service->get_user_list->@*;
    $self->render(users => \@users);
  }

  sub user_info($self) {
  }

  sub remove_user($self) {
    option( $self->param('id') )->match(
      Some => sub ($id) {
        $self->user_service->remove_user($id)->match(
          Right => sub { $self->redirect_to('/user-list') },
          Left  => sub { $self->redirect_to('/user-list') },
        );
      },
      None => sub { $self->redirect_to('/user-list') },
    );
  }

  sub user_register($self) {
    $self->render;
  }

  sub regist_user($self) {
    my $option = for_yield(
      [ map { option $self->param($_) } qw( first_name family_name ) ],
      sub ($first_name, $family_name) {
        $self->user_service->regist_user($first_name, $family_name);
      }
    );
    $option->match(
      Some => sub ($either) {
        $either->match(
          Right => sub { $self->redirect_to('/user-list') },
          Left  => sub { $self->redirect_to('/user-register') },
        );
      },
      None => sub { $self->redirect_to('/user-register') },
    );
  }

}

1;
