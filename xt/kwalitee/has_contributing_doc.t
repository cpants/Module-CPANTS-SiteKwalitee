use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../..";
use xt::kwalitee::Test;

xt::kwalitee::Test::run(

    # CONTRIBUTING
    ['JBERGER/Test-Mojo-WithRoles-0.02.tar.gz', 1],

    # CONTRIBUTING.md
    ['MRDVT/Math-Round-SignificantFigures-0.02.tar.gz', 1],

    # CONTRIBUTING.pod
    ['PACMAN/Method-Extension-0.2.tar.gz', 1],

    # multiple CONTRIBUTING files (.md, .pod)
    ['MRDVT/Package-Role-ini-0.07.tar.gz', 1],

    ['BRIANDFOY/Tie-Timely-1.026.tar.gz', 0],
);
