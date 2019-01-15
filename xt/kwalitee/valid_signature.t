use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../..";
use xt::kwalitee::Test;

xt::kwalitee::Test::run(
  ['HUGUEI/Net-Stomp-Receipt-0.36.tar.gz', 0], # 3686
  ['CRAIHA/Geo-Coordinates-Parser-0.01.tar.gz', 0], # 4009
  ['JJORE/perl-lint-mode-0.02.tar.gz', 0], # 4391
  ['DMAKI/Class-Validating-0.02.tar.gz', 0], # 4624
  ['SIMON/Lingua-EN-Keywords-2.0.tar.gz', 0], # 4639
  ['PELAGIC/List-Rotation-Cycle-1.009.tar.gz', 0], # 4648
  ['JMEHNLE/net-address-ipv4-local/Net-Address-IPv4-Local-0.12.tar.gz', 0], # 4848
  ['RPAGITSCH/Win32-Process-User-0.02.tar.gz', 0], # 5063
  ['HUGUEI/Finance-Currency-Convert-BChile-0.04.tar.gz', 0], # 5108
  ['RKOBES/File-HomeDir-Win32-0.04.tar.gz', 0, sub {
    my $stash = shift;
    ok $stash->{error}{valid_signature};
  }],
  ['RIVY/Win32-CommandLine-0.938.tar.gz', 1, sub {
    my $stash = shift;
    like $stash->{error}{valid_signature} => qr/Old SIGNATURE detected/;
  }],
);
