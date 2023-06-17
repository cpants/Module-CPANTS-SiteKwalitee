use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../..";
use xt::kwalitee::Test;

Test::More::plan skip_all => "This test requires databases";

xt::kwalitee::Test::run(
    ['ECARROLL/URI-http-Dump-0.03.tar.gz',            0],    # URI::http
    ['PMAKHOLM/Devel-RemoteTrace-0.3.tar.gz',         0],    # DB
    ['SIMKIN/Apache-LoggedAuthDBI-0.12.tar.gz',       0],    # DBI etc
    ['WILLERT/Catalyst-Model-EmailStore-0.03.tar.gz', 0],    # Email::Store::DBI
    ['KNM/Ambrosia-0.010.tar.gz',                     0],    # deferred
    ['HACHI/MogileFS-Plugin-MetaData-0.01.tar.gz',    0],    # MogileFS::Store
);
