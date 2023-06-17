use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../..";
use xt::kwalitee::Test;

Test::More::plan skip_all => "This test requires databases";

xt::kwalitee::Test::run(
    ['STEVAN/decorators-0.01.tar.gz',    0],    # Test::Fatal
    ['MANOWAR/WWW-KeenIO-0.02.tar.gz',   0],    # Test::Mouse
    ['JLMARTIN/CloudDeploy-1.05.tar.gz', 0],    # File::Slurp etc
    ['YANICK/Bread-Board-0.36.tar.gz',   0],    # Moo
);
