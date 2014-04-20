package #
  xt::kwalitee::Test;

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../Module-CPANTS-Analyse/lib";
use Test::More;

BEGIN {
  eval { require WorePAN };
  plan skip_all => "requires WorePAN" if $@ or $WorePAN::VERSION < 0.09;
}

use Module::CPANTS::Analyse;
use Module::CPANTS::SiteKwalitee;

sub run {
  my (@tests) = @_;

  my ($caller, $file) = caller;

  my ($name) = $file =~ /(\w+)\.t$/;

  plan tests => scalar @tests;

  for my $test (@tests) {
    my $worepan = WorePAN->new(
      root => "$FindBin::Bin/tmp",
      files => [$test->[0]],
      no_indices => 1,
      use_backpan => 1,
      no_network => 0,
      cleanup => 1,
    );
    my $tarball = $worepan->file($test->[0]);
    my $analyzer = Module::CPANTS::Analyse->new({dist => $tarball});
    $analyzer->mck(Module::CPANTS::SiteKwalitee->new);
    $analyzer->unpack;
    $analyzer->analyse;
    my $metric = $analyzer->mck->get_indicators_hash->{$name};
    $analyzer->calc_kwalitee if $metric->{aggregating};
    my $result = $metric->{code}->($analyzer->d, $metric);
    is $result => $test->[1], "$test->[0] $name: $result";
  }
}

1;
