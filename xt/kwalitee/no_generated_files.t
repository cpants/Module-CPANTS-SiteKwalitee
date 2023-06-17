use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../..";
use xt::kwalitee::Test;

xt::kwalitee::Test::run(
    ['SANTEX/Finance-Quant-Quotes-0.01.tar.gz',      0],    # 3159
    ['SANTEX/Finance-Quant-TA-0.01.tar.gz',          0],    # 3269
    ['TAKERU/Catalyst-Model-Estraier-v0.0.6.tar.gz', 0],    # 6175
    ['BDFOY/Unicode-Support-0.001.tar.gz',           0],    # 6633
    ['RPETTETT/Module-PortablePath-0.17.tar.gz',     0],    # 6951
    ['ROBN/Class-Constant-0.06.tar.gz',              0],    # 7557
    ['TUSHAR/Log-SelfHistory_0.1.tar.gz',            0],    # 8412
    ['CCCP/Plugins-Factory-0.01.tar.gz',             0],    # 8876
    ['JAMHED/Dancer-Plugin-Scoped-0.02fix.tar.gz',   0],    # 8885
    ['JKRAMER/SQL-Beautify-0.04.tar.gz',             0],    # 8972
);
