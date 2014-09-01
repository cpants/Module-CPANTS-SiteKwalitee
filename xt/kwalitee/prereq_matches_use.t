use strict;
use warnings;
use xt::kwalitee::Test;

Test::More::plan skip_all => "This test requires databases";

xt::kwalitee::Test::run(
  [ # a test module in t/lib, evaled build prereqs
  ['ISHIGAKI/Acme-CPANAuthors-0.20.tar.gz', 1],
  ['ISHIGAKI/Test-UseAllModules-0.14.tar.gz'],
  ['GBARR/CPAN-DistnameInfo-0.12.tar.gz'],
  ['KASEI/Class-Accessor-0.34.tar.gz'],
  ['MSCHWERN/Gravatar-URL-1.06.tar.gz'],
  ['DWHEELER/Test-Pod-1.48.tar.gz'],
  ['PETDANCE/Test-Pod-Coverage-1.08.tar.gz'],
  ['GAAS/libwww-perl-6.05.tar.gz'],
  ['CRENZ/Module-Find-0.11.tar.gz'],
  ['MAKAMAKA/JSON-2.57.tar.gz'],
  ['DOY/Try-Tiny-0.12.tar.gz'],

  ],
  [
  ['ETHER/Dist-Zilla-Plugin-Test-CleanNamespaces-0.004.tar.gz', 1],
  ['RJBS/Dist-Zilla-5.019.tar.gz'],
  ['ETHER/Moose-2.1209.tar.gz'],
  ['DAGOLDEN/MooseX-Types-Stringlike-0.003.tar.gz'],
  ['DAGOLDEN/Path-Tiny-0.054.tar.gz'],
  ['ETHER/namespace-autoclean-0.19.tar.gz'],
  ],
);
