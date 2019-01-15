use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../..";
use xt::kwalitee::Test;

Test::More::plan skip_all => "This test requires databases";

xt::kwalitee::Test::run(
  ['ISHIGAKI/Path-Extended-0.19.tar.gz', 1],
  ['TOKUHIROM/URI-Builder-0.01.tar.gz', 0],
);
