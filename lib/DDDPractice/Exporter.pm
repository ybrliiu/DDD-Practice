package DDDPractice::Exporter {

  use strictures version => 2;
  use utf8;
  use feature qw( :5.28 signatures );
  no warnings 'experimental::signatures';

  sub import($class) {

    my @pragmas = (
      +{ name => 'strictures', params => [ version => 2 ] },
      +{ name => 'utf8',       params => [] },
      +{ name => 'feature',    params => [qw( :5.28 signatures )] },
    );
    for my $pragma (@pragmas) {
      $pragma->{name}->import( $pragma->{params}->@* );
    }

    warnings->unimport('experimental::signatures');
  }

}

1;

__END__
