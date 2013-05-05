use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib";
use Test::More;
use Module::CPANTS::SiteKwalitee::Signature;
use Module::CPANTS::TestContext;

eval "use WorePAN 0.02; 1" or plan skip_all => "this test requires WorePAN 0.02";

my @tests = (
  ['R/RP/RPETTETT/Bio-Das-Lite-2.11.tar.gz', -2],
  ['K/KU/KUDARASP/PHP-Strings-0.28.tar.gz', -3],
  ['A/AL/ALEXMV/Net-Server-Coro-0.4.tar.gz', -4],
  ['A/AU/AUDREYT/use-0.01.tar.gz', -5],
);

for my $test (@tests) {
  my $worepan = WorePAN->new(
    root => "$FindBin::Bin/tmp",
    files => [$test->[0]],
    no_network => 0,
    cleanup => 1,
    use_backpan => 1,
  );

  $worepan->walk(callback => sub {
    my $dir = shift;

    my $context = Module::CPANTS::TestContext->new($dir);

    eval { Module::CPANTS::SiteKwalitee::Signature->analyse($context) };
    is $context->d->{error}{valid_signature} => $test->[1], "$test->[0]: $test->[1]";
  });
}

done_testing;
