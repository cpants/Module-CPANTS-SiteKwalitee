use strict;
use warnings;
use Test::More;
use Test::CPANfile;
use CPAN::Common::Index::MetaDB;

cpanfile_has_all_used_modules(
  recommends => 1,
  suggests => 1,
  index => CPAN::Common::Index::MetaDB->new,
);
done_testing;
