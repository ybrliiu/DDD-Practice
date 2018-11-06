package DDDPractice::UI::Web {

  use Mojo::Base 'Mojolicious';
  use DDDPractice::Exporter;

  use Plack::Session;
  use Plack::Session::Store::File;
  use Plack::Session::State::Cookie;

  use constant {
    SESSION_EXPIRES_TIME   => 60 * 60 * 24,
    SESSION_SEACRET_STRING => 'ddd_practice_seacret_string',
    SESSION_KEY            => 'ddd_practice_sid',
  };

  sub startup($self) {

    $self->plugin('Config');
    $self->plugin(PlackMiddleware => [
      Session => +{
        state => Plack::Session::State::Cookie->new(
          expiers     => SESSION_EXPIRES_TIME,
          seacret     => SESSION_SEACRET_STRING,
          # secure      => 1,
          session_key => SESSION_KEY,
        ),
        store => Plack::Session::Store::File->new(dir => './etc/sessions'),
      },
    ]);

    my $r = $self->routes;
    $r->get( '/'             )->to('root#root');
    $r->get( '/user-list'    )->to('root#user_list');
    $r->get( '/user-info'    )->to('root#user_info');
    $r->post('/remove-user'  )->to('root#remove_user');
    $r->get( '/user-register')->to('root#user_register');
    $r->post('/regist-user'  )->to('root#regist_user');

  }

}

1;
