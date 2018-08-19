package DDDPractice::UI::Web {

  use Mojo::Base 'Mojolicious';
  use DDDPractice::Exporter;

  sub startup($self) {

    $self->plugin('Config');

    my $r = $self->routes;
    $r->get( '/'             )->to('root#root');
    $r->get( '/user-list'    )->to('root#user_list');
    $r->get( '/user-info'    )->to('root#user_info');
    $r->post('/remove-user'  )->to('root#remove_user');
    $r->post('/user-register')->to('root#user_register');
    $r->post('/regist-user'  )->to('root#remove_user');

  }

}

1;
