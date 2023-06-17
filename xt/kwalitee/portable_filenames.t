use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../..";
use xt::kwalitee::Test;

xt::kwalitee::Test::run(
    ['DGL/Acme-mA-1337.1.tar.gz',                          0],    # 3411
    ['SCHWIGON/acme-unicode/Acme-Uenicoede-0.0501.tar.gz', 0],    # 3651
    ['DGL/Acme-3mxA-1337.37.tar.gz',                       0],    # 4093
    ['KOORCHIK/Mojolicious-Plugin-RenderFile-0.06.tar.gz', 0],    # 4114
);
