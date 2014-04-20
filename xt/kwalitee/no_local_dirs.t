use strict;
use warnings;
use xt::kwalitee::Test;

xt::kwalitee::Test::run(

  # local, but no .pm files
  ['ERMEYERS/Bundle-Modules-2006.0606.tar.gz', 1], # 29296

  # perl5 (with non-portable files)
  # ['PERLER/MooseX-Attribute-Deflator-2.1.3.tar.gz', 0], # 109876
  # fatlib
  ['GETTY/Installer-0.005.tar.gz', 0], # 295629
);
